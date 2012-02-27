# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.delete_all

User.create(  logon:      "igg856", 
              first_name: "Ilya", 
              last_name:  "Gvozdenko", 
              spectrum_number: "32 1111", 
              password: "",
              admin: true)
# . . .

User.create(  logon:      "b0x", 
              first_name: "Debbie", 
              last_name:  "Soxsmith", 
              spectrum_number: "32 2222", 
              password: "")
# . . .

User.create(  logon:      "w3t", 
              first_name: "Chris", 
              last_name:  "Martin", 
              spectrum_number: "32 3333", 
              password: "w3t",
              admin: true)
# . . .

# ConferenceNumber.delete_all

ConferenceNumber.create(conference_number: "55 1111")
# . . .
ConferenceNumber.create(conference_number: "55 2222")
# . . .
ConferenceNumber.create(conference_number: "55 3333")
# . . .

# Booking.delete_all
# 
Booking.create( conference_number_id: "1", 
                user_id:              "1", 
                date:                 "2012-02-11",
                time_start:           "2012-02-11 09:15:00.000000", 
                time_finish:          "2012-02-11 09:15:00.000000")
#                 
Booking.create( conference_number_id: "2", 
                user_id:              "2", 
                date:                 "2012-02-11",
                time_start:           "2012-02-11 09:15:00.000000", 
                time_finish:          "2012-02-11 09:15:00.000000")               
# # . . .     
#                    
Booking.create( conference_number_id: "3", 
                user_id:              "3", 
                date:                 "2012-02-11",
                time_start:           "2012-02-11 09:15:00.000000", 
                time_finish:          "2012-02-11 09:15:00.000000")
   


