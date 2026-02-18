import fs from "fs";
import path from "path";
import Juke from "../juke/index.js";
import { regQuery } from "./winreg.js";
import { homedir } from "os";

/**
 * Cached path to DM compiler
 */
let dmPath;

const BYOND_PATH_LINUX = "./tools/byond_install/byond";
const getDmPathLinux = async () => {
  const dreammakerPath = BYOND_PATH_LINUX + "/bin/DreamMaker";
  if (fs.existsSync(dreammakerPath)) {
    return dreammakerPath;
  }
  Juke.logger.warn(
    "Unable to locate DreamMaker from default installation path. Attempting to install.",
  );
  const installResponse = await Juke.exec("sh", [
    "-c",
    "tools/ci/install_byond.sh ./tools/byond_install",
  ]);
  if (installResponse.code !== 0) {
    Juke.logger.error("Failed to install DreamMaker");
    throw new Juke.ExitCode(1);
  }
  return getDmPathLinux();
};

const getDmPath = async () => {
  if (dmPath) {
    return dmPath;
  }
  dmPath = await (async () => {
    if (process.platform === "linux") {
      return await getDmPathLinux();
    }
    // Search in array of paths
    const paths = [
      ...((process.env.DM_EXE && process.env.DM_EXE.split(",")) || []),
      "C:\\Program Files\\BYOND\\bin\\dm.exe",
      "C:\\Program Files (x86)\\BYOND\\bin\\dm.exe",
      ["reg", "HKLM\\Software\\Dantom\\BYOND", "installpath"],
      ["reg", "HKLM\\SOFTWARE\\WOW6432Node\\Dantom\\BYOND", "installpath"],
    ];
    const isFile = (path) => {
      try {
        return fs.statSync(path).isFile();
      } catch (err) {
        return false;
      }
    };
    for (let path of paths) {
      // Resolve a registry key
      if (Array.isArray(path)) {
        const [type, ...args] = path;
        path = await regQuery(...args);
      }
      if (!path) {
        continue;
      }
      // Check if path exists
      if (isFile(path)) {
        return path;
      }
      if (isFile(path + "/dm.exe")) {
        return path + "/dm.exe";
      }
      if (isFile(path + "/bin/dm.exe")) {
        return path + "/bin/dm.exe";
      }
    }
    // Default paths
    return (process.platform === "win32" && "dm.exe") || "DreamMaker";
  })();
  return dmPath;
};

/**
 * @param {string} dmeFile
 * @param {{
 *   defines?: string[];
 *   warningsAsErrors?: boolean;
 * }} options
 */
export const DreamMaker = async (dmeFile, options = {}) => {
  const dmPath = await getDmPath();
  // Get project basename
  const dmeBaseName = dmeFile.replace(/\.dme$/, "");
  // Make sure output files are writable
  const testOutputFile = (name) => {
    try {
      fs.closeSync(fs.openSync(name, "r+"));
    } catch (err) {
      if (err && err.code === "ENOENT") {
        return;
      }
      if (err && err.code === "EBUSY") {
        Juke.logger.error(
          `File '${name}' is locked by the DreamDaemon process.`,
        );
        Juke.logger.error(`Stop the currently running server and try again.`);
        throw new Juke.ExitCode(1);
      }
      throw err;
    }
  };
  testOutputFile(`${dmeBaseName}.dmb`);
  testOutputFile(`${dmeBaseName}.rsc`);
  const runWithWarningChecks = async (dmeFile, args) => {
    if (process.platform === "linux") {
      Juke.logger.info("Inserting LD_LIBRARY_PATH and BYOND_SYSTEM.");
      const ldLibrary = BYOND_PATH_LINUX + "/bin";
      const byondSystem = BYOND_PATH_LINUX;
      process.env.LD_LIBRARY_PATH = ldLibrary;
      process.env.BYOND_SYSTEM = byondSystem;
    }
    const execReturn = await Juke.exec(dmeFile, args);
    if (
      options.warningsAsErrors &&
      execReturn.combined.match(/\d+:warning: /)
    ) {
      Juke.logger.error(`Compile warnings treated as errors`);
      throw new Juke.ExitCode(2);
    }
    return execReturn;
  };
  // Compile
  const { defines } = options;
  if (defines && defines.length > 0) {
    Juke.logger.info("Using defines:", defines.join(", "));
  }
  Juke.logger.info("DreamMaker path: ", dmPath);
  await runWithWarningChecks(dmPath, [
    ...defines.map((def) => `-D${def}`),
    dmeFile,
  ]);
};

export const DreamDaemon = async (dmbFile, ...args) => {
  const dmPath = await getDmPath();
  const baseDir = path.dirname(dmPath);
  const ddExeName =
    process.platform === "win32" ? "dreamdaemon.exe" : "DreamDaemon";
  if (process.platform === "linux") {
    Juke.logger.info("Inserting LD_LIBRARY_PATH and BYOND_SYSTEM.");
    const ldLibrary = byondPathLinux() + "/bin";
    const byondSystem = byondPathLinux();
    process.env.LD_LIBRARY_PATH = ldLibrary;
    process.env.BYOND_SYSTEM = byondSystem;
  }
  const ddExePath = baseDir === "." ? ddExeName : path.join(baseDir, ddExeName);
  return Juke.exec(ddExePath, [dmbFile, ...args]);
};
