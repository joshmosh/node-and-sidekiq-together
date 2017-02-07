"use strict"

require("dotenv").config()

const Hapi = require("hapi");
const Joi = require("joi");
const Redis = require("redis");
const Sidekiq = require("sidekiq");
const Mongoose = require("mongoose");

Mongoose.connect(process.env.MONGO_URL)
Mongoose.Promise = global.Promise;

const Schema = Mongoose.Schema;

const PersonSchema = new Schema({
  first_name: { type: String },
  last_name: { type: String },
  processed: { type: Boolean, default: false },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now }
})

const PersonModel = Mongoose.model("Person", PersonSchema)

let redis = Redis.createClient();

const sidekiq = new Sidekiq(redis);
const server = new Hapi.Server();

server.connection({ port: 3005, host: "0.0.0.0" });

server.route({
  method: "POST",
  path: "/people",
  config: {
    validate: {
      payload: {
        first_name: Joi.string().min(3).max(10).required(),
        last_name: Joi.string().min(3).max(10).required()
      }
    }
  },
  handler: function(request, reply) {
    var person = new PersonModel(request.payload);

    person.save((err, new_person) => {
      if(err) reply(err);

      sidekiq.enqueue("FetchAndUpdatePersonWorker", [new_person.id], {
        queue: "default"
      });

      reply(new_person.toObject()).code(201);
    });
  }
});

server.start((err) => {
  if(err) {
    throw err;
  }

  console.log(`Server running at: ${server.info.uri}`);
});
