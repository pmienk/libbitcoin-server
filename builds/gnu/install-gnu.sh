#!/bin/bash
###############################################################################
#  Copyright (c) 2014-2026 libbitcoin-server developers (see COPYING).
#
#         GENERATED SOURCE CODE, DO NOT EDIT EXCEPT EXPERIMENTALLY
#
###############################################################################
# Script managing the build and installation of libbitcoin-server and its dependencies.
#
# Script options:
# --build-boost               Build Boost libraries
# --build-secp256k1           Build libsecp256k1 libraries
# --build-src-dir=<path>      Location of sources.
# --build-obj-dir=<path>      Location of intermedia objects.
# --build-obj-dir-relative    Use build-obj-dir as relative to project sources.
# --build-config=<mode>       Specifies the build configuration.
#                               Valid values: { debug, release }
# --build-link=<mode>         Specifies link mode.
#                               Valid values: { dynamic, static }
# --build-full-repositories   Sync full github repositories.
#                               Default clones depth 1, single branch
# --build-parallel=<int>      Number of jobs to run simultaneously.
#                               Default: discovery
# --build-use-local-src       Use existing sources in build-src-dir path.
# --prefix=<path>             Library install location.
#                               Default: /usr/local
# --verbose                   Display verbose script output.
# --help, -h                  Display usage, overriding script execution.
#
# All unrecognized options provided shall be passed as configuration
# options for all dependencies.

OPTS_ENABLE="set -eo pipefail"
OPTS_DISABLE="set +e"

eval "${OPTS_ENABLE}"
trap 'echo "FATAL ERROR: Command failed at line ${LINENO}: ${BASH_COMMAND}" >&2' ERR

SEQUENTIAL=1

if [[ -z ${boost_URLBASE} ]]; then
    boost_URLBASE="https://archives.boost.io/release/1.86.0/source/"
fi
if [[ -z ${boost_FILENAME} ]]; then
    boost_FILENAME="boost_1_86_0.tar.bz2"
fi

if [[ -z ${secp256k1_OWNER} ]]; then
    secp256k1_OWNER="bitcoin-core"
fi
if [[ -z ${secp256k1_TAG} ]]; then
    secp256k1_TAG="v0.7.0"
fi

if [[ -z ${libbitcoin_system_OWNER} ]]; then
    libbitcoin_system_OWNER="pmienk"
fi
if [[ -z ${libbitcoin_system_TAG} ]]; then
    libbitcoin_system_TAG="installer-rewrite"
fi

if [[ -z ${libbitcoin_database_OWNER} ]]; then
    libbitcoin_database_OWNER="pmienk"
fi
if [[ -z ${libbitcoin_database_TAG} ]]; then
    libbitcoin_database_TAG="installer-rewrite"
fi

if [[ -z ${libbitcoin_network_OWNER} ]]; then
    libbitcoin_network_OWNER="pmienk"
fi
if [[ -z ${libbitcoin_network_TAG} ]]; then
    libbitcoin_network_TAG="installer-rewrite"
fi

if [[ -z ${libbitcoin_node_OWNER} ]]; then
    libbitcoin_node_OWNER="pmienk"
fi
if [[ -z ${libbitcoin_node_TAG} ]]; then
    libbitcoin_node_TAG="installer-rewrite"
fi

if [[ -z ${libbitcoin_server_OWNER} ]]; then
    libbitcoin_server_OWNER="pmienk"
fi
if [[ -z ${libbitcoin_server_TAG} ]]; then
    libbitcoin_server_TAG="installer-rewrite"
fi

main()
{
    # argument consumption

    for OPTION in "$@"; do
        case ${OPTION} in
            (--build-boost)             BUILD_boost="yes";;
            (--build-secp256k1)         BUILD_secp256k1="yes";;
            (--build-src-dir=*)         BUILD_SRC_DIR="${OPTION#*=}";;
            (--build-obj-dir=*)         BUILD_OBJ_DIR="${OPTION#*=}";;
            (--build-obj-dir-relative)  BUILD_OBJ_DIR_RELATIVE="yes";;
            (--build-config=*)          BUILD_CONFIG="${OPTION#*=}";;
            (--build-link=*)            BUILD_LINK="${OPTION#*=}";;
            (--build-full-repositories) BUILD_FULL_REPOSITORIES="yes";;
            (--build-use-local-src)     BUILD_USE_LOCAL_SRC="yes";;
            (--build-parallel=*)        PARALLEL="${OPTION#*=}";;
            (--prefix=*)                PREFIX="${OPTION#*=}";;
            (--verbose)                 DISPLAY_VERBOSE="yes";;
            (--help|-h)                 DISPLAY_HELP="yes";;
        esac
    done

    CONFIGURE_OPTIONS_ORIGINAL=("$@")
    CONFIGURE_OPTIONS=("$@")
    CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--build-*/}")
    CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--prefix=*/}")
    CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--verbose/}")
    display_message_verbose "*** ARGUMENTS: ${CONFIGURE_OPTIONS_ORIGINAL[*]}"
    display_message_verbose "*** SANITIZED: ${CONFIGURE_OPTIONS[*]}"

    if [[ "${DISPLAY_VERBOSE}" == "yes" ]]; then
        display_build_variables
    fi


    OS=$(uname -s)

    # defaults and sanitization: script static options

    # --build-src-dir
    if [[ -z "${BUILD_SRC_DIR}" ]]; then
        BUILD_SRC_DIR="$(pwd)"
        display_message_verbose "No build-src-dir specified, using default '${BUILD_SRC_DIR}'."
    fi

    if [[ -d "${BUILD_SRC_DIR}" ]]; then
        push_directory "${BUILD_SRC_DIR}"
        BUILD_SRC_DIR="$(pwd)"
        pop_directory
        display_message_verbose "Determined absolute path for build-src-dir '${BUILD_SRC_DIR}'."
    else
        create_directory "${BUILD_SRC_DIR}"
        push_directory "${BUILD_SRC_DIR}"
        BUILD_SRC_DIR="$(pwd)"
        pop_directory
        display_message_verbose "Created build-src-dir '${BUILD_SRC_DIR}'."
    fi

    # --build-obj-dir
    if [[ -z "${BUILD_OBJ_DIR}" ]]; then
        if [[ "${BUILD_OBJ_DIR_RELATIVE}" == "yes" ]]; then
            BUILD_OBJ_DIR="obj"
            display_message_verbose "No build-obj-dir specified, using relative default '${BUILD_OBJ_DIR}'."
        else
            BUILD_OBJ_DIR="$(pwd)/obj"
            display_message_verbose "No build-obj-dir specified, using default '${BUILD_OBJ_DIR}'."
        fi
    fi

    if [[ "${BUILD_OBJ_DIR_RELATIVE}" == "yes" ]]; then
        display_message_verbose "Deferring relative path action for build-obj-dir '${BUILD_OBJ_DIR}'."
    else
        if [[ -d "${BUILD_OBJ_DIR}" ]]; then
            push_directory "${BUILD_OBJ_DIR}"
            BUILD_OBJ_DIR="$(pwd)"
            pop_directory
            display_message_verbose "Determined absolute path for build-obj-dir '${BUILD_OBJ_DIR}'."
       else
            create_directory "${BUILD_OBJ_DIR}"
            push_directory "${BUILD_OBJ_DIR}"
            BUILD_OBJ_DIR="$(pwd)"
            pop_directory
            display_message_verbose "Created build-obj-dir '${BUILD_OBJ_DIR}'."
        fi
    fi

    # --build-config
    if [[ -z "${BUILD_CONFIG}" ]]; then
        display_message_verbose "No build-config specified."
    elif [[ "${BUILD_CONFIG}" != "debug" ]] && [[ "${BUILD_CONFIG}" != "release" ]]; then
        display_error "Provided build-config '${BUILD_CONFIG}' not a valid value."
        display_help
        exit 1
    else
        display_message_verbose "Using provided build-config '${BUILD_CONFIG}'"
    fi

    # --build-link
    if [[ -z "${BUILD_LINK}" ]]; then
        display_message_verbose "No build-link specified."
    elif [[ "${BUILD_LINK}" != "dynamic" ]] && [[ "${BUILD_LINK}" != "static" ]]; then
        display_error "Provided build-link ${BUILD_LINK}' not a valid value."
        display_help
        exit 1
    fi

    # --prefix
    if [[ -z "${PREFIX}" ]]; then
        # Always set a prefix (required for OSX and lib detection).
        PREFIX="/usr/local"
        display_message_verbose "No prefix specified, defaulting to '${PREFIX}'."
    else
        # Incorporate the custom libdir into each object, for link time resolution
        if [[ -z "${LD_RUN_PATH}" ]]; then
            export LD_RUN_PATH="${PREFIX}/lib"
        else
            export LD_RUN_PATH="${LD_RUN_PATH}:${PREFIX}/lib"
        fi

        if [[ -z "${LD_LIBRARY_PATH}" ]]; then
            export LD_LIBRARY_PATH="${PREFIX}/lib"
        else
            export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${PREFIX}/lib"
        fi
    fi

    if [[ -n "${PREFIX}" ]]; then
        CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]}" "--prefix=${PREFIX}" )
    fi

    if [[ -n "${PREFIX}" ]]; then
        # Set the prefix-based package config directory.
        PREFIX_PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"

        # Prioritize prefix package config in PKG_CONFIG_PATH search path.
        if [[ -n "${PKG_CONFIG_PATH}" ]]; then
            export PKG_CONFIG_PATH="${PREFIX_PKG_CONFIG_PATH}:${PKG_CONFIG_PATH}"
        else
            export PKG_CONFIG_PATH="${PREFIX_PKG_CONFIG_PATH}"
        fi

        with_pkgconfigdir="--with-pkgconfigdir=${PREFIX_PKG_CONFIG_PATH}"
    fi

    # --parallel
    if [[ -z "${PARALLEL}" ]]; then
        if [[ ${OS} == Linux ]]; then
            PARALLEL=$(nproc)
        elif [[ ${OS} == Darwin ]] || [[ ${OS} == OpenBSD ]]; then
            PARALLEL=$(sysctl -n hw.ncpu)
        else
            display_error "Unsupported system: '${OS}'"
            display_error "  Unable to determine value for '--parallel='"
            display_error "  Please specify explicitly to continue."
            display_error ""
            display_help
            exit 1
        fi
    fi

    # state rationalization of standard build variables

    if [[ ${OS} == OpenBSD ]]; then
        make() { gmake "$@"; }
    fi

    if [[ -z "${STDLIB}" ]]; then
        if [[ ${OS} == Darwin ]]; then
            STDLIB="c++"
        elif [[ ${OS} == OpenBSD ]]; then
            STDLIB="estdc++"
        else
            STDLIB="stdc++"
        fi
    else
        define_message_verbose "STDLIB using defined value '${STDLIB}'"
    fi

    if [[ -z "${CC}" ]]; then
        if [[ ${OS} == Darwin ]]; then
            export CC="clang"
        elif [[ ${OS} == OpenBSD ]]; then
            export CC="egcc"
        fi
    else
        display_message_verbose "CC using defined value '${CC}'"
    fi

    if [[ -z "${CXX}" ]]; then
        if [[ ${OS} == Darwin ]]; then
            export CXX="clang++"
        elif [[ ${OS} == OpenBSD ]]; then
            export CXX="eg++"
        fi
    else
        display_message_verbose "CXX using defined value '${CXX}'"
    fi

    # translate BUILD_CONFIG to ZFLAGS
    if [[ -n "${BUILD_CONFIG}" ]]; then
        display_message_verbose "*** Build config specified, calculating flags..."

        if [[ "${BUILD_CONFIG}" == "debug" ]]; then
            BUILD_FLAGS="-Og -g"
        elif [[ "${BUILD_CONFIG}" == "release" ]]; then
            BUILD_FLAGS="-O3"
        fi

        if [[ -z "${CFLAGS}" ]]; then
            export CFLAGS="${BUILD_FLAGS}"
            display_message_verbose "Exporting CFLAGS '${CFLAGS}'"
        else
            display_message_verbose "CFLAGS intitally '${CFLAGS}'"
            SANITIZED_CFLAGS=$(strip_optimization "$CFLAGS")
            export CFLAGS="${SANITIZED_CFLAGS} ${BUILD_FLAGS}"
            display_message_verbose "CFLAGS modified to '${CFLAGS}'"
        fi

        if [[ -z "${CXXFLAGS}" ]]; then
            export CXXFLAGS="${BUILD_FLAGS}"
            display_message_verbose "Exporting CXXFLAGS '${CXXFLAGS}'"
        else
            display_message_verbose "CXXFLAGS intitally '${CXXFLAGS}'"
            SANITIZED_CXXFLAGS=$(strip_optimization "$CXXFLAGS")
            export CXXFLAGS="${SANITIZED_CXXFLAGS} ${BUILD_FLAGS}"
            display_message_verbose "CXXFLAGS modified to '${CXXFLAGS}'"
        fi
    fi

    # Specify or remove --enable-ndebug for gnu toolchain on release
    if [[ "${BUILD_CONFIG}" == "debug" ]]; then
        CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--enable-ndebug/}")
    elif [[ "${BUILD_CONFIG}" == "release" ]]; then
        CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]}" "--enable-ndebug" )
    fi

    # translate BUILD_LINK to appropriate arguments
    if [[ -n "${BUILD_LINK}" ]]; then
        CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]/--disable-shared=*}" )
        CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]/--enable-shared=*}" )
        CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]/--disable-static=*}" )
        CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]/--enable-static=*}" )

        if [[ "${BUILD_LINK}" == "dynamic" ]]; then
            CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]}" "--enable-shared" "--disable-static" )
        else
            CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]}" "--disable-shared" "--enable-static" )
        fi
    fi

    if [[ ${OS} == Linux && ${CC} == clang* ]] || [[ ${OS} == OpenBSD ]]; then
        export LDLIBS="-l${STDLIB} ${LDLIBS}"
        display_message_verbose "LDLIBS has been manipulated to encode STDLIB linkage."
    fi

    # defaults and sanitization: generated options

    if [[ -n "${BUILD_boost}" ]]; then
        export BOOST_ROOT="${PREFIX}"
        with_boost="--with-boost=${PREFIX}"
    fi


    # handle help
    if [[ "${DISPLAY_HELP}" == "yes" ]]; then
        display_help
        return 0
    fi

    display_heading_message "Configuration"
    display_build_variables

    display_heading_message "Toolchain Configuration Parameters"
    display_toolchain_variables

    if [[ "${DISPLAY_VERBOSE}" == "yes" ]]; then
        display_heading_message "State"
        display_constants
    fi

    # declarations

    boost_FLAGS=(
        "-Wno-enum-constexpr-conversion")

    boost_OPTIONS=(
        "--with-iostreams"
        "--with-locale"
        "--with-program_options"
        "--with-regex"
        "--with-thread"
        "--with-url"
        "--with-test")

    secp256k1_FLAGS=(
        "-w")

    secp256k1_OPTIONS=(
        "--disable-tests"
        "--enable-experimental"
        "--enable-module-recovery"
        "--enable-module-schnorrsig")

    libbitcoin_system_FLAGS=()

    libbitcoin_system_OPTIONS=(
        "--without-tests"
        "--without-examples"
        "${with_boost}"
        "${with_pkgconfigdir}")

    libbitcoin_database_FLAGS=()

    libbitcoin_database_OPTIONS=(
        "--without-tests"
        "--without-tools"
        "${with_boost}"
        "${with_pkgconfigdir}")

    libbitcoin_network_FLAGS=()

    libbitcoin_network_OPTIONS=(
        "--without-tests"
        "${with_boost}"
        "${with_pkgconfigdir}")

    libbitcoin_node_FLAGS=()

    libbitcoin_node_OPTIONS=(
        "--without-tests"
        "${with_boost}"
        "${with_pkgconfigdir}")

    libbitcoin_server_FLAGS=()

    libbitcoin_server_OPTIONS=(
        "${with_boost}"
        "${with_pkgconfigdir}")

    if [[ ${BUILD_boost} == "yes" ]]; then
        source_archive "boost" "${boost_FILENAME}" "${boost_URLBASE}" "bzip2"
        local SAVE_CPPFLAGS="${CPPFLAGS}"
        export CPPFLAGS="${CPPFLAGS} ${boost_FLAGS[@]}"
        build_boost "boost" "${boost_OPTIONS[@]}"
        export CPPFLAGS="${SAVE_CPPFLAGS}"
    fi

    if [[ ${BUILD_secp256k1} == "yes" ]]; then
        source_github "${secp256k1_OWNER}" "secp256k1" "${secp256k1_TAG}"
        local SAVE_CPPFLAGS="${CPPFLAGS}"
        export CPPFLAGS="${CPPFLAGS} ${secp256k1_FLAGS[@]}"
        build_gnu "secp256k1" "." "${PARALLEL}" "${secp256k1_OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}"
        install_make "secp256k1"
        export CPPFLAGS="${SAVE_CPPFLAGS}"
    fi

    source_github "${libbitcoin_system_OWNER}" "libbitcoin-system" "${libbitcoin_system_TAG}"
    local SAVE_CPPFLAGS="${CPPFLAGS}"
    export CPPFLAGS="${CPPFLAGS} ${libbitcoin_system_FLAGS[@]}"
    build_gnu "libbitcoin-system" "." "${PARALLEL}" "${libbitcoin_system_OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}"
    install_make "libbitcoin-system"
    export CPPFLAGS="${SAVE_CPPFLAGS}"

    source_github "${libbitcoin_database_OWNER}" "libbitcoin-database" "${libbitcoin_database_TAG}"
    local SAVE_CPPFLAGS="${CPPFLAGS}"
    export CPPFLAGS="${CPPFLAGS} ${libbitcoin_database_FLAGS[@]}"
    build_gnu "libbitcoin-database" "." "${PARALLEL}" "${libbitcoin_database_OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}"
    install_make "libbitcoin-database"
    export CPPFLAGS="${SAVE_CPPFLAGS}"

    source_github "${libbitcoin_network_OWNER}" "libbitcoin-network" "${libbitcoin_network_TAG}"
    local SAVE_CPPFLAGS="${CPPFLAGS}"
    export CPPFLAGS="${CPPFLAGS} ${libbitcoin_network_FLAGS[@]}"
    build_gnu "libbitcoin-network" "." "${PARALLEL}" "${libbitcoin_network_OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}"
    install_make "libbitcoin-network"
    export CPPFLAGS="${SAVE_CPPFLAGS}"

    source_github "${libbitcoin_node_OWNER}" "libbitcoin-node" "${libbitcoin_node_TAG}"
    local SAVE_CPPFLAGS="${CPPFLAGS}"
    export CPPFLAGS="${CPPFLAGS} ${libbitcoin_node_FLAGS[@]}"
    build_gnu "libbitcoin-node" "." "${PARALLEL}" "${libbitcoin_node_OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}"
    install_make "libbitcoin-node"
    export CPPFLAGS="${SAVE_CPPFLAGS}"

    source_github "${libbitcoin_server_OWNER}" "libbitcoin-server" "${libbitcoin_server_TAG}"
    local SAVE_CPPFLAGS="${CPPFLAGS}"
    export CPPFLAGS="${CPPFLAGS} ${libbitcoin_server_FLAGS[@]}"
    build_gnu "libbitcoin-server" "." "${PARALLEL}" "${libbitcoin_server_OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}"
    test_make "libbitcoin-server" "check" "${PARALLEL}"
    install_make "libbitcoin-server"
    export CPPFLAGS="${SAVE_CPPFLAGS}"

    display_message "Completed successfully."
}

display_build_variables()
{
    display_message "BUILD_boost                     : ${BUILD_boost}"
    display_message "BUILD_secp256k1                 : ${BUILD_secp256k1}"
    display_message "BUILD_SRC_DIR                   : ${BUILD_SRC_DIR}"
    display_message "BUILD_OBJ_DIR                   : ${BUILD_OBJ_DIR}"
    display_message "BUILD_OBJ_DIR_RELATIVE          : ${BUILD_OBJ_DIR_RELATIVE}"
    display_message "BUILD_CONFIG                    : ${BUILD_CONFIG}"
    display_message "BUILD_LINK                      : ${BUILD_LINK}"
    display_message "BUILD_FULL_REPOSITORIES         : ${BUILD_FULL_REPOSITORIES}"
    display_message "BUILD_USE_LOCAL_SRC             : ${BUILD_USE_LOCAL_SRC}"
    display_message "PARALLEL                        : ${PARALLEL}"
    display_message "PREFIX                          : ${PREFIX}"
    display_message "DISPLAY_VERBOSE                 : ${DISPLAY_VERBOSE}"
    display_message "CONFIGURE_OPTIONS               : ${CONFIGURE_OPTIONS[*]}"
if [[ "${DISPLAY_VERBOSE}" == "yes" ]]; then
    display_message "CONFIGURE_OPTIONS_ORIGINAL      : ${CONFIGURE_OPTIONS_ORIGINAL[*]}"
fi

}

display_toolchain_variables()
{

    display_message "CC                              : ${CC}"
    display_message "CFLAGS                          : ${CFLAGS}"
    display_message "CXX                             : ${CXX}"
    display_message "CXXFLAGS                        : ${CXXFLAGS}"
    display_message "LD_RUN_PATH                     : ${LD_RUN_PATH}"
    display_message "LD_LIBRARY_PATH                 : ${LD_LIBRARY_PATH}"
    display_message "PKG_CONFIG_PATH                 : ${PKG_CONFIG_PATH}"
    display_message "LDLIBS                          : ${LDLIBS}"
    display_message "BOOST_ROOT                      : ${BOOST_ROOT}"
}

display_constants()
{
    display_message "boost_URLBASE                   : ${boost_URLBASE}"
    display_message "boost_FILENAME                  : ${boost_FILENAME}"

    display_message "secp256k1_OWNER                 : ${secp256k1_OWNER}"
    display_message "secp256k1_TAG                   : ${secp256k1_TAG}"

    display_message "libbitcoin_system_OWNER         : ${libbitcoin_system_OWNER}"
    display_message "libbitcoin_system_TAG           : ${libbitcoin_system_TAG}"

    display_message "libbitcoin_database_OWNER       : ${libbitcoin_database_OWNER}"
    display_message "libbitcoin_database_TAG         : ${libbitcoin_database_TAG}"

    display_message "libbitcoin_network_OWNER        : ${libbitcoin_network_OWNER}"
    display_message "libbitcoin_network_TAG          : ${libbitcoin_network_TAG}"

    display_message "libbitcoin_node_OWNER           : ${libbitcoin_node_OWNER}"
    display_message "libbitcoin_node_TAG             : ${libbitcoin_node_TAG}"

    display_message "libbitcoin_server_OWNER         : ${libbitcoin_server_OWNER}"
    display_message "libbitcoin_server_TAG           : ${libbitcoin_server_TAG}"
}

display_help()
{
    display_message "Script managing the build and installation of libbitcoin-server and its dependencies."
    display_message ""
    display_message "Script options:"
    display_message "--build-boost               Build Boost libraries"
    display_message "--build-secp256k1           Build libsecp256k1 libraries"
    display_message "--build-src-dir=<path>      Location of sources."
    display_message "--build-obj-dir=<path>      Location of intermedia objects."
    display_message "--build-obj-dir-relative    Use build-obj-dir as relative to project sources."
    display_message "--build-config=<mode>       Specifies the build configuration."
    display_message "                              Valid values: { debug, release }"
    display_message "--build-link=<mode>         Specifies link mode."
    display_message "                              Valid values: { dynamic, static }"
    display_message "--build-full-repositories   Sync full github repositories."
    display_message "                              Default clones depth 1, single branch"
    display_message "--build-parallel=<int>      Number of jobs to run simultaneously."
    display_message "                              Default: discovery"
    display_message "--build-use-local-src       Use existing sources in build-src-dir path."
    display_message "--prefix=<path>             Library install location."
    display_message "                              Default: /usr/local"
    display_message "--verbose                   Display verbose script output."
    display_message "--help, -h                  Display usage, overriding script execution."
    display_message ""
    display_message "All unrecognized options provided shall be passed as configuration"
    display_message "options for all dependencies."
}

display_heading_message()
{
    printf "\n********************** %s **********************\n" "$@"
}

display_message()
{
    printf "%s\n" "$@"
}

display_message_verbose()
{
    if [[ "${DISPLAY_VERBOSE}" == "yes" ]]; then
        display_message "$@"
    fi
}

display_error()
{
    >&2 printf "%s\n" "$@"
}

create_directory()
{
    local DIRECTORY="$1"
    local MODE="$2"

    if [[ -d "${DIRECTORY}" ]]; then
        if [[ ${MODE} == "-f" ]]; then
            display_message "Reinitializing '${DIRECTORY}'..."
            rm -rf "${DIRECTORY}"
            mkdir -p "${DIRECTORY}"
        else
            display_message "Reusing existing '${DIRECTORY}'..."
        fi
    else
        display_message "Initializing '${DIRECTORY}'..."
        mkdir -p "${DIRECTORY}"
    fi
}

create_directory_force()
{
    create_directory "$@" -f
}

pop_directory()
{
    display_message_verbose "*** move  pre: '$(pwd)'"
    popd >/dev/null
    display_message_verbose "*** move post: '$(pwd)'"
}

push_directory()
{
    display_message_verbose "*** move  pre: '$(pwd)'"
    local DIRECTORY="$1"
    pushd "${DIRECTORY}" >/dev/null
    display_message_verbose "*** move post: '$(pwd)'"
}

remove_directory_force()
{
    display_message_verbose "*** removing: '$@'"
    rm -rf "$@"
}

enable_exit_on_error()
{
    eval "${OPTS_ENABLE}"
}

disable_exit_on_error()
{
    eval "${OPTS_DISABLE}"
}

display_configure_options()
{
    display_message "configure options:"
    for OPTION in "$@"; do
        if [[ -n ${OPTION+set} ]]; then
            display_message "${OPTION}"
        fi
    done
}

strip_optimization()
{
    echo "$1" | sed -E '
        s/-O([0-3]|s|fast|g|z|size|speed)?b?/ /g
        s/-g([0-3]|gdb|dwarf[0-9]*)?b?/ /g
        s/[[:space:]]+/ /g
        s/^ | $//g
    '
}

source_archive()
{
    local PROJECT="$1"
    local FILENAME="$2"
    local URL_BASE="$3"
    local COMPRESSION="$4"
    shift 4

    display_heading_message "Preparing to acquire ${PROJECT}"

    push_directory "${BUILD_SRC_DIR}"

    if [ -d "${PROJECT}" ] &&
       [[ "${BUILD_USE_LOCAL_SRC}" == "yes" ]]; then
        display_message "Reusing existing '${PROJECT}' directory..."
        return 0
    fi

    if [ -d "${PROJECT}" ]; then
        display_message "Encounted existing '${PROJECT}' directory, removing..."
        remove_directory_force "${PROJECT}"
    fi

    display_message "Retrieving ${PROJECT}..."

    create_directory "${PROJECT}"
    push_directory "${PROJECT}"

    local TAR="tar"
    local WGET="wget --quiet"

    # retrieve file
    ${WGET} --output-document "${FILENAME}" "${URL_BASE}${FILENAME}"
    # ${WGET} --output-document "${FILENAME}" "${URL_BASE}${FILENAME}"

    # extract to expected path
    ${TAR} --extract --file "${FILENAME}" --${COMPRESSION} --strip-components=1
    # ${TAR} --extract --file "${FILENAME}" "--${COMPRESSION}" --strip-components=1

    # pop ${PROJECT}
    pop_directory

    # pop ${BUILD_SRC_DIR}
    pop_directory

    display_message "Completed download and extraction successfully."
}

source_github()
{
    local OWNER="$1"
    local REPOSITORY="$2"
    local TAG="$3"
    shift 3

    display_heading_message "Preparing to acquire ${OWNER}/${REPOSITORY}/${TAG}"

    local GIT_CLONE="git clone"
    local CLONE_OPTIONS="--depth 1 --single-branch"

    if [[ "${BUILD_FULL_REPOSITORIES}" == "yes" ]]; then
        CLONE_OPTIONS=""
    fi

    push_directory "${BUILD_SRC_DIR}"

    if [ -d "${REPOSITORY}" ] &&
       [[ "${BUILD_USE_LOCAL_SRC}" == "yes" ]]; then
        display_message "Reusing existing '${REPOSITORY}'..."
        pop_directory # BUILD_SRC_DIR
        return 0
    fi

    if [ -d "${REPOSITORY}" ]; then
        display_message "Encounted existing '${REPOSITORY}' directory, removing..."
        remove_directory_force "${REPOSITORY}"
    fi

    display_message "Cloning ${OWNER}/${REPOSITORY}/${TAG}..."

    ${GIT_CLONE} ${CLONE_OPTIONS} --branch "${TAG}" "https://github.com/${OWNER}/${REPOSITORY}"

    # pop BUILD_SRC_DIR
    pop_directory
}

install_make()
{
    local PROJECT="$1"
    shift

    display_message "Preparing to install ${PROJECT}"

    push_directory "${BUILD_SRC_DIR}/${PROJECT}"

    if [[ "${BUILD_OBJ_DIR_RELATIVE}" == "yes" ]]; then
        push_directory "${BUILD_OBJ_DIR}"
    else
        push_directory "${BUILD_OBJ_DIR}/${PROJECT}"
    fi

    make install

    if [[ ${OS} == Linux ]] && [[ "${PREFIX}" == "/usr/local" ]]; then
        ldconfig
    fi

    pop_directory # BUILD_OBJ_DIR
    pop_directory # BUILD_SRC_DIR/PROJECT

    display_message "'${PROJECT}' installation compelete."
}

test_make()
{
    local PROJECT="$1"
    local TARGET="$2"
    local JOBS="$3"
    shift 3

    display_message "Preparing to test ${PROJECT}"

    push_directory "${BUILD_SRC_DIR}/${PROJECT}"

    if [[ "${BUILD_OBJ_DIR_RELATIVE}" == "yes" ]]; then
        push_directory "${BUILD_OBJ_DIR}"
    else
        push_directory "${BUILD_OBJ_DIR}/${PROJECT}"
    fi

    disable_exit_on_error

    if [[ ${JOBS} -gt ${SEQUENTIAL} ]]; then
        make -j${JOBS} ${TARGET} VERBOSE=1
    else
        make ${TARGET} VERBOSE=1
    fi

    local RESULT=$?

    # Test runners emit to the test.log file.
    if [[ -e "test.log" ]]; then
        cat "test.log"
    fi

    enable_exit_on_error

    if [[ ${RESULT} -ne 0 ]]; then
        exit ${RESULT}
    fi

    pop_directory # BUILD_OBJ_DIR
    pop_directory # BUILD_SRC_DIR/PROJECT

    display_message "'${PROJECT}' test compelete."
}

build_boost()
{
    local PROJECT="$1"
    shift

    display_heading_message "Preparing to build ${PROJECT}"

    push_directory "${BUILD_SRC_DIR}/${PROJECT}"

    local SAVE_IFS="${IFS}"
    IFS=' '

    # Compute configuration
    if [[ "${BUILD_LINK}" == "dynamic" ]]; then
        BOOST_LINK="shared"
    elif [[ "${BUILD_LINK}" == "static" ]]; then
        BOOST_LINK="static"
    else
        BOOST_LINK="static,shared"
    fi

    if [[ -n ${CC} ]]; then
        BOOST_TOOLSET="toolset=${CC}"
    fi

    if [[ (${OS} == Linux && ${CC} == clang*) || (${OS} == OpenBSD) ]]; then
        STDLIB_FLAG="-stdlib=lib${STDLIB}"
        BOOST_CXXFLAGS="cxxflags=${STDLIB_FLAG}"
        BOOST_LINKFLAGS="linkflags=${STDLIB_FLAG}"
    fi

    guessed_toolset=`${BUILD_SRC_DIR}/${PROJECT}/tools/build/src/engine/build.sh --guess-toolset`
    CXXFLAGS="-w" ${BUILD_SRC_DIR}/${PROJECT}/tools/build/src/engine/build.sh ${guessed_toolset} --cxxflags="-w"
    cp "${BUILD_SRC_DIR}/${PROJECT}/tools/build/src/engine/b2" .

    if [[ -n "${BOOST_CXXFLAGS}" ]]; then
        BOOST_CXXFLAGS="${BOOST_CXXFLAGS} ${boost_FLAGS[@]}"
    else
        BOOST_CXXFLAGS="cxxflags=${boost_FLAGS[@]}"
    fi

    # Prebuild status report
    display_message "${PROJECT} configuration."
    display_message "--------------------------------------------------------------------"
    display_message "variant               : release"
    display_message "threading             : multi"
    display_message "toolset               : ${CC}"
    display_message "boost cxxflags        : ${BOOST_CXXFLAGS}"
    display_message "boost linkflags       : ${BOOST_LINKFLAGS}"
    display_message "link                  : ${BOOST_LINK}"
    display_message "-sNO_BZIP2            : 1"
    display_message "-sNO_ZSTD             : 1"
    display_message "-j                    : ${PARALLEL}"
    display_message "-d0                   : [supress informational messages]"
    display_message "-q                    : [stop at the first error]"
    display_message "--reconfigure         : [ignore cached configuration]"
    display_message "--prefix              : ${PREFIX}"
    display_message "BOOST_OPTIONS         : $*"
    display_message "cxxflags (ignored)    : ${CXXFLAGS}"
    display_message "--------------------------------------------------------------------"

    # Begin build
    ./bootstrap.sh --with-bjam=./b2 --prefix=${PREFIX}

    ./b2 install \
        "cxxstd=20" \
        "variant=release" \
        "threading=multi" \
        "${BOOST_TOOLSET}" \
        "${BOOST_CXXFLAGS}" \
        "${BOOST_LINKFLAGS}" \
        "link=${BOOST_LINK}" \
        "warnings=off" \
        "-sNO_BZIP2=1" \
        "-sNO_ZSTD=1" \
        "-j ${PARALLEL}" \
        "-d0" \
        "-q" \
        "--reconfigure" \
        "--prefix=${PREFIX}" \
        "$@"

    IFS="${SAVE_IFS}"

    pop_directory # BUILD_SRC_DIR
}

build_gnu()
{
    local PROJECT="$1"
    local RELATIVE_PATH="$2"
    local JOBS="$3"
    shift 3

    local VERBOSITY_GNU=""
    local VERBOSITY_MAKE=""

    if [[ "${DISPLAY_VERBOSE}" == "yes" ]]; then
        VERBOSITY_GNU="--verbose"
        VERBOSITY_MAKE="VERBOSE=1"
    fi

    display_heading_message "Preparing to build ${PROJECT}"


    # directory rationalization
    push_directory "${BUILD_SRC_DIR}/${PROJECT}"
    push_directory "${RELATIVE_PATH}"
    local BUILD_PATH="$(pwd)"
    pop_directory

    if [[ "${BUILD_OBJ_DIR_RELATIVE}" == "yes" ]]; then
        create_directory_force "${BUILD_OBJ_DIR}"
        push_directory "${BUILD_OBJ_DIR}"
    else
        push_directory "${BUILD_OBJ_DIR}"
        create_directory_force "${PROJECT}"
        pop_directory
        push_directory "${BUILD_OBJ_DIR}/${PROJECT}"
    fi

    # configuration
    push_directory "${BUILD_PATH}"
    autoreconf ${VERBOSITY_GNU} -i
    pop_directory # BUILD_PATH

    display_configure_options "$@"

    "${BUILD_PATH}/configure" ${VERBOSITY_GNU} "$@"

    # make
    if [[ ${JOBS} -gt ${SEQUENTIAL} ]]; then
        make -j${JOBS} ${VERBOSITY_MAKE}
    else
        make
    fi

    pop_directory # BUILD_OBJ_DIR
    pop_directory # BUILD_SRC_DIR/PROJECT
    display_message "'${PROJECT}' built successfully."
}

main "$@"
