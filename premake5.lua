BX_DIR = path.getabsolute("")
printf('BX_DIR: %s', BX_DIR)

------ DEFINTIONS FOR FILE ------
----
-- BX_BUILD_DIR - overrides BX's build directory.
-- BX_OBJ_DIR   - overrides BX's intermediate build directory.
----
---------------------------------

function bx_include_compat()
	filter { 'system:windows', 'action:gmake' }
		includedirs { path.join(BX_DIR, 'include/compat/mingw') }
	filter "action:vs*"
		includedirs { path.join(BX_DIR, 'include/compat/msvc') }
  filter 'system:linux'
    includedirs { path.join(BX_DIR, 'include/compat/linux') }
	filter 'system:macosx' 
		includedirs { path.join(BX_DIR, 'include/compat/osx') }
    buildoptions { "-x objective-c++" }
  filter '*'
end

project 'bx'
  kind 'staticlib'
  language 'c++'
  cppdialect 'c++17'

  exceptionhandling 'off'
  rtti 'off'

  targetname('bx')
  targetdir(BX_BUILD_DIR or 'build/%{prj.config}/bin')
  objdir(BX_OBJ_DIR or 'build/%{prj.config}/obj')

  files {
    'include/bx/**.h',
    'include/bx/**.inl',

    'src/**.cpp',
  }
	removefiles {
		"src/amalgamated.cpp",
		"src/crtnone.cpp",
	}

	includedirs {
		"3rdparty/",
		"include/",
	}

  bx_include_compat()
