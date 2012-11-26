require 'formula'

class Pcl < Formula
  homepage 'http://www.pointclouds.org'
  version '1.5.1'
  url 'http://www.pointclouds.org/assets/files/1.5.1/PCL-1.5.1-Source.tar.bz2'
	sha256 '6ab3b0a95e78888ff9779ec841e398f8b96c20eda4a3ce65ee647c1d7cc2b637'

	devel do
  version '1.6.0'
		url 'http://www.pointclouds.org/assets/files/1.6.0/PCL-1.6.0-Source.tar.bz2'
		sha256 '3d384a37ce801a75c8995801e650a5e2c13e0d67541aa676cad4fa27996ce346'
	end

  head 'svn+ssh://svn@svn.pointclouds.org/pcl/trunk'

	fails_with :clang do
		build 421
		cause "Compilation fails with clang"
	end

  depends_on 'cmake'
  depends_on 'boost149'
  depends_on 'eigen'
  depends_on 'flann'
  depends_on 'cminpack'
  depends_on 'vtk'
  depends_on 'qhull'
  depends_on 'libusb'

  depends_on 'doxygen' if ARGV.include? '--doc'
  depends_on 'sphinx'  if ARGV.include? '--doc'

  def options
  [
    [ '--apps'           , "Build apps"                      ],
    [ '--doc'            , "Build documentation"             ],
    [ '--nofeatures'     , "Disable features module"         ],
    [ '--nofilters'      , "Disable filters module"          ],
    [ '--noio'           , "Disable io module"               ],
    [ '--nokdtree'       , "Disable kdtree module"           ],
    [ '--nokeypoints'    , "Disable keypoints module"        ],
    [ '--nooctree'       , "Disable octree module"           ],
    [ '--noproctor'      , "Disable proctor module"          ],
    [ '--nopython'       , "Disable Python bindings"         ],
    [ '--norangeimage'   , "Disable range image module"      ],
    [ '--noregistration' , "Disable registration module"     ],
    [ '--nosac'          , "Disable sample consensus module" ],
    [ '--nosearch'       , "Disable search module"           ],
    [ '--nosegmentation' , "Disable segmentation module"     ],
    [ '--nosurface'      , "Disable surface module"          ],
    [ '--notools'        , "Disable tools module"            ],
    [ '--notracking'     , "Disable tracking module"         ],
    [ '--novis'          , "Disable visualisation module"    ],
    [ '--with-debug'     , "Enable gdb debugging"            ],
  ]
  end

  def install
    args = std_cmake_parameters.split

		args << "-DBUILD_apps:BOOL=OFF" if ARGV.include? '--noapps'
    if ARGV.include? '--doc'
      args << "-DBUILD_documentation:BOOL=ON"
    else
      args << "-DBUILD_documentation:BOOL=OFF"
    end
		args << "-DBUILD_features:BOOL=OFF"       if ARGV.include? '--nofeatures'
		args << "-DBUILD_filters:BOOL=OFF"        if ARGV.include? '--nofilters'
		args << "-DBUILD_io:BOOL=OFF"             if ARGV.include? '--noio'
		args << "-DBUILD_kdtree:BOOL=OFF"         if ARGV.include? '--nokdtree'
		args << "-DBUILD_keypoints:BOOL=OFF"      if ARGV.include? '--nokeypoints'
		args << "-DBUILD_octree:BOOL=OFF"         if ARGV.include? '--nooctree'
		args << "-DBUILD_proctor:BOOL=OFF"        if ARGV.include? '--noproctor'
		args << "-DBUILD_python:BOOL=OFF"         if ARGV.include? '--nopython'
		args << "-DBUILD_rangeimage:BOOL=OFF"     if ARGV.include? '--norangeimage'
		args << "-DBUILD_registration:BOOL=OFF"   if ARGV.include? '--noregistration'
		args << "-DBUILD_sac:BOOL=OFF"            if ARGV.include? '--nosac'
		args << "-DBUILD_search:BOOL=OFF"         if ARGV.include? '--nosearch'
		args << "-DBUILD_segmentation:BOOL=OFF"   if ARGV.include? '--nosegmentation'
		args << "-DBUILD_surface:BOOL=OFF"        if ARGV.include? '--nosurface'
		args << "-DBUILD_tools:BOOL=OFF"          if ARGV.include? '--notools'
		args << "-DBUILD_tracking:BOOL=OFF"       if ARGV.include? '--notracking'
		args << "-DBUILD_visualization:BOOL=OFF"  if ARGV.include? '--novis'

    if ARGV.include? '--with-debug'
			args.delete '-DCMAKE_BUILD_TYPE=None'
			args << "-DCMAKE_BUILD_TYPE=Debug"
			args << "-DCMAKE_C_FLAGS_DEBUG=-ggdb3 -O0"
			args << "-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3 -O0"
    end

		boost149_base    = Formula.factory('boost149').installed_prefix
		boost149_include = File.join(boost149_base, 'include')
		args << "-DBoost_INCLUDE_DIR=#{boost149_include}"

    system "mkdir build"
    args << ".."
    Dir.chdir 'build' do
      system "cmake", *args
      system "make install"
    end
  end

  def test
    system "bash -c 'echo | plyheader'"
  end
end
