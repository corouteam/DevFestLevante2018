const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);


exports.updateBookmarks = functions.firestore
    .document('users/{bookmarks}')
    .onUpdate((change, context) => {
        const payload = {
            notification:{
                title : "Aggiunto!",
                body : "Verrai notificato in prossimità dell'evento",
                badge : '1',
                sound : 'default'
            }
        }
        console.log('Aggiornatooo');

        functions.firestore.document('users/{notificationsToken}').
        const token = Object.keys(allToken.val())
        admin.messaging().sendToDevice(token,payload)
    });