#!/usr/bin/env node
/* eslint-disable no-console */
const fs = require("fs");
const path = require("path");

const admin = require("firebase-admin");

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 1) {
    const item = argv[i];
    if (!item.startsWith("--")) {
      continue;
    }
    const key = item.slice(2);
    const next = argv[i + 1];
    if (next && !next.startsWith("--")) {
      args[key] = next;
      i += 1;
    } else {
      args[key] = true;
    }
  }
  return args;
}

function printUsage() {
  console.log(
    [
      "Usage:",
      "  node scripts/update_courses.js \\",
      "    --serviceAccount /path/to/service-account.json \\",
      "    --createdBy <uid|uid1,uid2,...> \\",
      "    [--collection courses] \\",
      "    [--createdAt server|<ISO-8601>] \\",
      "",
      "Examples:",
      "  node scripts/update_courses.js --serviceAccount ./service.json --createdBy abc123",
      "  node scripts/update_courses.js --serviceAccount ./service.json --createdBy sinan,ozan,yigit",
      "  node scripts/update_courses.js --serviceAccount ./service.json --createdBy abc123 --createdAt 2024-10-01T12:00:00Z",
    ].join("\n")
  );
}

function resolveServiceAccount(serviceAccountPath) {
  if (!serviceAccountPath) {
    return null;
  }
  const resolved = path.isAbsolute(serviceAccountPath)
    ? serviceAccountPath
    : path.join(process.cwd(), serviceAccountPath);
  if (!fs.existsSync(resolved)) {
    return null;
  }
  return resolved;
}

function buildCreatedAt(value) {
  if (!value || value === "server") {
    return admin.firestore.FieldValue.serverTimestamp();
  }
  const date = new Date(value);
  if (Number.isNaN(date.valueOf())) {
    throw new Error(
      "Invalid --createdAt value. Use 'server' or an ISO-8601 timestamp."
    );
  }
  return admin.firestore.Timestamp.fromDate(date);
}

function parseCreatedBy(value) {
  if (!value) {
    return [];
  }
  return value
    .split(",")
    .map((item) => item.trim())
    .filter(Boolean);
}

function pickRandom(values) {
  if (values.length === 0) {
    return null;
  }
  const index = Math.floor(Math.random() * values.length);
  return values[index];
}

async function updateCourses({
  serviceAccountPath,
  createdByList,
  collectionName = "courses",
  createdAtValue = "server",
}) {
  const serviceAccount = require(serviceAccountPath);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  const db = admin.firestore();
  const snapshot = await db.collection(collectionName).get();
  if (snapshot.empty) {
    console.log(`No documents found in collection '${collectionName}'.`);
    return;
  }

  const createdAtField = buildCreatedAt(createdAtValue);
  let batch = db.batch();
  let batchCount = 0;
  let updatedCount = 0;
  let scannedCount = 0;

  for (const doc of snapshot.docs) {
    scannedCount += 1;
    const data = doc.data() || {};
    const updates = {};

    if (data.createdBy == null || data.createdBy === "") {
      const picked = pickRandom(createdByList);
      if (picked != null) {
        updates.createdBy = picked;
      }
    }

    if (data.createdAt == null) {
      updates.createdAt = createdAtField;
    }

    if (data.faculty === "Business School") {
      updates.faculty = "Sabancı Business School";
    }

    if (Object.keys(updates).length > 0) {
      batch.update(doc.ref, updates);
      batchCount += 1;
      updatedCount += 1;
    }

    if (batchCount >= 450) {
      await batch.commit();
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
  }

  console.log(
    `Scanned ${scannedCount} docs, updated ${updatedCount} docs in '${collectionName}'.`
  );
}

async function main() {
  const args = parseArgs(process.argv);
  const serviceAccountPath = resolveServiceAccount(args.serviceAccount);
  const createdByList = parseCreatedBy(args.createdBy);

  if (!serviceAccountPath || createdByList.length === 0) {
    printUsage();
    process.exit(1);
  }

  try {
    await updateCourses({
      serviceAccountPath,
      createdByList,
      collectionName: args.collection || "courses",
      createdAtValue: args.createdAt || "server",
    });
  } catch (error) {
    console.error("Failed to update courses:", error.message);
    process.exit(1);
  }
}

main();
