module Paths_haq (
	version,
	getBinDir, getLibDir, getDataDir, getLibexecDir,
	getDataFileName
	) where

import Data.Version

version :: Version
version = Version {versionBranch = [0,0], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/Users/edt/bin"
libdir     = "/Users/edt/lib/haq-0.0/ghc-6.8.2"
datadir    = "/Users/edt/share/haq-0.0"
libexecdir = "/Users/edt/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = return bindir
getLibDir = return libdir
getDataDir = return datadir
getLibexecDir = return libexecdir

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = return (datadir ++ "/" ++ name)
