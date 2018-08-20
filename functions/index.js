let functions = require('firebase-functions');
let admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


// exports.banana = functions.firestore
//     .document('users/{userId}')
//     .onWrite((change, context) => {
//         console.log(`new create event for document ID: ${context.params.userId.notificationToken}`);
//         var token = context.params.notificationToken;

//         const payload = {
//             notification: {
//                 title:"Hai aggiunto un preferito!",
//                 body: "Figo!",
//                 sound: "default"
//             },
//         };

//         return admin.messaging().sendToDevice(token, payload)


//     });