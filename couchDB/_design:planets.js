{
   "_id": "_design/planets",
   "_rev": "6-b7f9de3f1bfab3fb03b58a5b57890137",
   "language": "javascript",
   "views": {
       "find_planets_from_user": {
           "map": "function(doc) {\n  var planet_id, nickname, value;\n  if (doc.username && doc.planets) {\n      for (nickname in doc.planets) {\n          planet_id = doc.planets[nickname];\n          emit(nickname, planet_id);\n      }\n  }\n}"
       },
       "list_planets": {
           "map": "function(doc) {\n  var planet_id, nickname, value;\n  if (doc.planet_name) {\n\n emit(doc.planet_name, doc._id);\n\n  }\n}"
       },
       "unread_events_per_planet": {
           "map": "function(doc) {\n  var key;\n  if (doc.target_planet_id && doc.has_been_read === false) {\n\tkey=[doc.target_planet_id, doc.date];\n \temit(key, doc.body);\n\n  }\n}"
       }
   }
}