const admin = require('firebase-admin');
const functions = require('firebase-functions');
const serviceAccount = require('./firebase.json');
const fs = require('fs');
const csvSync = require('csv-parse/lib/sync');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
let workoutMenuRef = db.collection('workoutMenus');

let data = fs.readFileSync("./workout_menu_source.csv");
let workoutMenuList = csvSync(data);

const run = async () => {
  for (var i = 0; i < workoutMenuList.length; i++) {
    const item = workoutMenuList[i]
    const id = `${i + 1}`;
    await workoutMenuRef.doc(id).set({
      id: id,
      name: item[0],
      description: `対象部位 ${item[1]}`
    });
  }
}

run().then(() => {});