const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const database = admin.firestore();

// exports.timerUpdate = functions.pubsub.schedule('* * * * *').onRun((context) => {
//     database.doc("timers/timer1").update({ "time": admin.firestore.Timestamp.now() });
//     return console.log('successful timer update');
// });

exports.sendNotification = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
        const now = admin.firestore.Timestamp.now();
    const nextMinute = new admin.firestore.Timestamp(now.seconds + 60, now.nanoseconds);

    // Query for documents where the notification time is within the next minute
    const query = await database.collection("notifications")
        .where("whenToNotify1", '>=', now)
        .where("whenToNotify1", '<', nextMinute)
        .get();

    await Promise.all(query.docs.map(async (snapshot) => {
        const data = snapshot.data();
        await sendNotification(data.token);
    }));

    console.log('End Of Function');

    async function sendNotification(androidNotificationToken) {
        let title = "isha";
        let body = "Comes at the right time";

        const message = {
            notification: { title: title, body: body },
            token: androidNotificationToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };

        try {
            await admin.messaging().send(message);
            console.log("Successful Message Sent");
        } catch (error) {
            console.error("Error Sending Message", error);
        }
    }
});



exports.sendNotificationsendNotificationfajrrrrrr = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const nextMinute = new admin.firestore.Timestamp(now.seconds + 60, now.nanoseconds);

    // Query for documents where the notification time is within the next minute
    const query = await database.collection("notifications")
        .where("whenToNotify2", '>=', now)
        .where("whenToNotify2", '<', nextMinute)
        .get();

    await Promise.all(query.docs.map(async (snapshot) => {
        const data = snapshot.data();
        await sendNotification(data.token);
    }));

    console.log('End Of Function');

    async function sendNotification(androidNotificationToken) {
        let title = "fajr";
        let body = "Comes at the right time";

        const message = {
            notification: { title: title, body: body },
            token: androidNotificationToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };

        try {
            await admin.messaging().send(message);
            console.log("Successful Message Sent");
        } catch (error) {
            console.error("Error Sending Message", error);
        }
    }
});






exports.sendNotificationDhuhr = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
  
       const now = admin.firestore.Timestamp.now();
    const nextMinute = new admin.firestore.Timestamp(now.seconds + 60, now.nanoseconds);

    // Query for documents where the notification time is within the next minute
    const query = await database.collection("notifications")
        .where("whenToNotify3", '>=', now)
        .where("whenToNotify3", '<', nextMinute)
        .get();

    await Promise.all(query.docs.map(async (snapshot) => {
        const data = snapshot.data();
        await sendNotification(data.token);
    }));

    console.log('End Of Function');

    async function sendNotification(androidNotificationToken) {
        let title = "Dhuhr";
        let body = "Comes at the right time";

        const message = {
            notification: { title: title, body: body },
            token: androidNotificationToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };

        try {
            await admin.messaging().send(message);
            console.log("Successful Message Sent");
        } catch (error) {
            console.error("Error Sending Message", error);
        }
    }
});





exports.sendNotificationAsr = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
        const now = admin.firestore.Timestamp.now();
    const nextMinute = new admin.firestore.Timestamp(now.seconds + 60, now.nanoseconds);

    // Query for documents where the notification time is within the next minute
    const query = await database.collection("notifications")
        .where("whenToNotify4", '>=', now)
        .where("whenToNotify4", '<', nextMinute)
        .get();

    await Promise.all(query.docs.map(async (snapshot) => {
        const data = snapshot.data();
        await sendNotification(data.token);
    }));

    console.log('End Of Function');

    async function sendNotification(androidNotificationToken) {
        let title = "ASR";
        let body = "Comes at the right time";

        const message = {
            notification: { title: title, body: body },
            token: androidNotificationToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };

        try {
            await admin.messaging().send(message);
            console.log("Successful Message Sent");
        } catch (error) {
            console.error("Error Sending Message", error);
        }
    }
});





exports.sendNotificationMaghrib = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const nextMinute = new admin.firestore.Timestamp(now.seconds + 60, now.nanoseconds);

    // Query for documents where the notification time is within the next minute
    const query = await database.collection("notifications")
        .where("whenToNotify4", '>=', now)
        .where("whenToNotify4", '<', nextMinute)
        .get();

    await Promise.all(query.docs.map(async (snapshot) => {
        const data = snapshot.data();
        await sendNotification(data.token);
    }));

    console.log('End Of Function');

    async function sendNotification(androidNotificationToken) {
        let title = "Magrib";
        let body = "Comes at the right time";

        const message = {
            notification: { title: title, body: body },
            token: androidNotificationToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };

        try {
            await admin.messaging().send(message);
            console.log("Successful Message Sent");
        } catch (error) {
            console.error("Error Sending Message", error);
        }
    }
});






exports.sendNotificationIsha = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const nextMinute = new admin.firestore.Timestamp(now.seconds + 60, now.nanoseconds);

    // Query for documents where the notification time is within the next minute
    const query = await database.collection("notifications")
        .where("whenToNotify5", '>=', now)
        .where("whenToNotify5", '<', nextMinute)
        .get();

    await Promise.all(query.docs.map(async (snapshot) => {
        const data = snapshot.data();
        await sendNotification(data.token);
    }));

    console.log('End Of Function');

    async function sendNotification(androidNotificationToken) {
        let title = "isha";
        let body = "Comes at the right time";

        const message = {
            notification: { title: title, body: body },
            token: androidNotificationToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };

        try {
            await admin.messaging().send(message);
            console.log("Successful Message Sent");
        } catch (error) {
            console.error("Error Sending Message", error);
        }
    }
});



//--------------------




// Utility function to check and update the date in Firestore if the day changes
async function checkAndUpdateTime() {
    const now = new Date();
    const currentHour = now.getHours();
    const currentMinute = now.getMinutes();

    // Check if the current time is exactly midnight (00:00)
    if (currentHour === 0 && currentMinute === 0) {
        console.log("Midnight reached, updating day/month/year if necessary.");

        // Increment the day
        const dateToCheck = new Date();
        dateToCheck.setDate(dateToCheck.getDate() + 1); // Move to the next day

        const newDateString = dateToCheck.toISOString().split('T')[0]; // Format as YYYY-MM-DD

        try {
            // Update Firestore with the new date
            await database.doc("timers/currentDate").set({ date: newDateString });
            console.log("Day, month, or year updated successfully to:", newDateString);

            // Updating notification times to the next day's appropriate times
            const notificationsRef = database.collection("notifications");
            const notifications = await notificationsRef.get();

            notifications.forEach(async (doc) => {
                const data = doc.data();
                let updateData = {};

                // Loop through each notification field and prepare the update object
                for (let i = 1; i <= 5; i++) {
                    const notificationField = `whenToNotify${i}`;
                    
                    if (data[notificationField]) {
                        // Calculate new notification date for each field
                        let nextNotificationDate = data[notificationField].toDate();
                        nextNotificationDate.setDate(nextNotificationDate.getDate() + 1); // Move to the next day
                        
                        // Add the new date to the update object
                        updateData[notificationField] = admin.firestore.Timestamp.fromDate(nextNotificationDate);
                    }
                }

                // Perform a single update with all notification fields
                await notificationsRef.doc(doc.id).update(updateData);
                console.log(`Updated notification times for document ${doc.id} to the next day.`);
            });

        } catch (error) {
            console.error("Error updating date in Firestore:", error);
        }
    } else {
        console.log("It is not midnight yet.");
    }
}

// Scheduled function to run every day at midnight to check and update the date
exports.checkTimeDaily = functions.pubsub.schedule('0 0 * * *').onRun(async (context) => {
    await checkAndUpdateTime();
    console.log("Daily time check function executed.");
});

