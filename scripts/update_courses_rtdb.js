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
      "  node scripts/update_courses_rtdb.js \\",
      "    --serviceAccount /path/to/service-account.json \\",
      "    --databaseUrl https://<project>.firebaseio.com \\",
      "    --createdBy <uid> \\",
      "    [--path courses] \\",
      "    [--createdAt server|<ISO-8601>]",
      "",
      "Examples:",
      "  node scripts/update_courses_rtdb.js --serviceAccount ./service.json \\",
      "    --databaseUrl https://surate-65a27-default-rtdb.europe-west1.firebasedatabase.app \\",
      "    --createdBy abc123",
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
    return admin.database.ServerValue.TIMESTAMP;
  }
  const date = new Date(value);
  if (Number.isNaN(date.valueOf())) {
    throw new Error(
      "Invalid --createdAt value. Use 'server' or an ISO-8601 timestamp."
    );
  }
  return date.getTime();
}

async function updateCourses({
  serviceAccountPath,
  databaseUrl,
  createdBy,
  basePath = "courses",
  createdAtValue = "server",
}) {
  const serviceAccount = require(serviceAccountPath);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: databaseUrl,
  });

  const ref = admin.database().ref(basePath);
  const snapshot = await ref.get();

  if (!snapshot.exists()) {
    console.log(`No data found at path '${basePath}'.`);
    return;
  }

  const data = snapshot.val();
  if (data == null || typeof data !== "object") {
    console.log(`Expected an object map at '${basePath}', got:`, typeof data);
    return;
  }

  const createdAtField = buildCreatedAt(createdAtValue);
  const updates = {};
  let scannedCount = 0;
  let updatedCount = 0;

  for (const [key, value] of Object.entries(data)) {
    scannedCount += 1;
    if (value == null || typeof value !== "object") {
      continue;
    }

    const update = {};
    if (value.createdBy == null || value.createdBy === "") {
      update.createdBy = createdBy;
    }
    if (value.createdAt == null) {
      update.createdAt = createdAtField;
    }
    if (value.faculty === "Business School") {
      update.faculty = "Sabancı Business School";
    }

    const updateKeys = Object.keys(update);
    if (updateKeys.length > 0) {
      updatedCount += 1;
      for (const field of updateKeys) {
        updates[`${key}/${field}`] = update[field];
      }
    }
  }

  if (Object.keys(updates).length === 0) {
    console.log(`Scanned ${scannedCount} records, no updates needed.`);
    return;
  }

  await ref.update(updates);
  console.log(
    `Scanned ${scannedCount} records, updated ${updatedCount} records at '${basePath}'.`
  );
}

async function main() {
  const args = parseArgs(process.argv);
  const serviceAccountPath = resolveServiceAccount(args.serviceAccount);
  const databaseUrl = args.databaseUrl;
  const createdBy = args.createdBy;

  if (!serviceAccountPath || !databaseUrl || !createdBy) {
    printUsage();
    process.exit(1);
  }

  try {
    await updateCourses({
      serviceAccountPath,
      databaseUrl,
      createdBy,
      basePath: args.path || "courses",
      createdAtValue: args.createdAt || "server",
    });
  } catch (error) {
    console.error("Failed to update courses:", error.message);
    process.exit(1);
  }
}

main();
