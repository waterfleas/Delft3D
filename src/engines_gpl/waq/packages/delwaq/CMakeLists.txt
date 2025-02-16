# Define include directories
# Note that the CMAKE_CURRENT_SOURCE_DIR has a path to THIS CMakeLists location
set(waq_root_path ${CMAKE_CURRENT_SOURCE_DIR}/../../) # Trace back to the WAQ path
include_directories(${waq_root_path}/include)

# Set version file variables
set(waq_version_path ${waq_root_path}/version)

set(ini_version_file ${waq_version_path}/version_number.ini)
set(fortran_version_file ${CMAKE_CURRENT_SOURCE_DIR}/src/delwaq_version.F90)
set(rc_version_file ${waq_version_path}/version_number.rc)

# Generate version files
generate_version_files(${rc_version_file} 
                       ${waq_root_path}
                       ${ini_version_file} 
                       ON)

generate_version_files(${fortran_version_file} 
                       ${waq_root_path}
                       ${ini_version_file} 
                       ON)

# Set directory which contains all source files
set(src_path src)

# Gather source files
get_fortran_source_files(${src_path} source_files)
file(GLOB preprocessor_files ${CMAKE_CURRENT_SOURCE_DIR}/${src_path}/waq_bmi.F90)

# Define library
set(library_name delwaq_dll)
add_library(${library_name} SHARED ${source_files}
                                   ${rc_version_file})

# Define prebuild events
prebuild_version_number(${library_name} ${rc_version_file} 
                                        ${waq_root_path}
                                        ${ini_version_file}
                                        ON)

prebuild_version_number(${library_name} ${fortran_version_file} 
                                        ${waq_root_path}
                                        ${ini_version_file}
                                        ON)

# Set additional compilation properties
target_compile_options(${library_name} PRIVATE "${extend_source132_flag}")

set_source_files_properties(${fortran_version_file}
                            ${preprocessor_files}
                            PROPERTIES COMPILE_OPTIONS "${file_preprocessor_flag}")

# Set dependencies
set(oss_dependencies    deltares_common
                        deltares_common_c
                        delftio
                        delftio_shm
                        esmfsm
                        io_netcdf
                        nefis
                        netcdf4
                        netcdff
                        part_data_f
                        part_io_f
                        part_kernel_f
                        part_utils_f
                        waq_io
                        waq_kernel
                        waq_plugin_wasteload
                        waq_process
                        waq_utils_c
                        waq_utils_f) 
oss_include_libraries(${library_name} oss_dependencies)
target_link_libraries(${library_name} ${oss_dependencies})

if (WIN32)

    include_directories(${mpich2_path})

    # Set linker properties
    message(STATUS "Setting linker properties in windows")
    target_link_directories(${library_name}
                            PUBLIC
                            "${checkout_src_root}/third_party_open/netcdf/netCDF 4.6.1/lib"
                            "${checkout_src_root}/third_party_open/mpich2/x64/lib"
                            "${checkout_src_root}/third_party_open/pthreads/bin/x64")


    target_link_libraries(${library_name}
                            "libiomp5md.lib"
                            "fmpich2.lib"
                            "WbeMuuid.lib"
                            "ole32.lib"
                            "oleaut32.lib"
                            "wsock32.lib"
                            "netapi32.lib"
                            "comctl32.lib"
                            "user32.lib"
                            "advapi32.lib"
                            "comdlg32.lib"
                            "gdi32.lib"
                            "winspool.lib" 
                            "netcdf.lib")

    # Set linker options
    message(STATUS "Setting target_link_options in windows")
    target_link_options(${library_name} PRIVATE ${nologo_flag})
endif(WIN32)

if(UNIX)
    target_link_libraries(${library_name} ${oss_dependencies})
endif(UNIX)

# Define how the files should be structured within Visual Studio
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${source_files})
source_group(Resources FILES    ${rc_version_file})

set_target_properties (${library_name} PROPERTIES FOLDER engines_gpl/waq)

# Change the name of the target library to delwaq.dll
set_target_properties (${library_name} PROPERTIES OUTPUT_NAME delwaq)

# Set post-build step
set(install_dir ${CMAKE_BINARY_DIR})
set(build_dir ${CMAKE_BINARY_DIR})

post_build_target (${library_name}
                   ${install_dir} 
                   ${build_dir} 
                   ${checkout_src_root} 
                   ${library_name})

install(TARGETS ${library_name} DESTINATION lib)
