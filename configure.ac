###############################################################################
#  Copyright (c) 2014-2025 libbitcoin-server developers (see COPYING).
#
#         GENERATED SOURCE CODE, DO NOT EDIT EXCEPT EXPERIMENTALLY
#
###############################################################################

# Standard declarations.
#==============================================================================
# Requires Automake 1.14 or newer.

# Declare the required version of Autoconf.
AC_PREREQ([2.65])

# Process command-line arguments and perform initialization and verification.
AC_INIT([libbitcoin-server], [4.0.0], [eric@voskuil.org])

# Do compilation tests.
AC_LANG(C++)

# Specify the temporary directory for build tools.
AC_CONFIG_AUX_DIR([build-aux])

# Specify the directory of additional local Autoconf macros.
AC_CONFIG_MACRO_DIR([m4])

# Run macros for operation of generated Makefiles, enable non-recursive make.
# Unless [foreign] is specified standard GNU files will be required,
# specifically: AUTHORS, COPYING, INSTALL, NEWS, README and ChangeLog.
AM_INIT_AUTOMAKE([subdir-objects])

# Enable C and POSIX extensions that may be disabled on certain platforms.
AC_USE_SYSTEM_EXTENSIONS

# Enable the archiver.
AM_PROG_AR

# Initialize libtool.
LT_PREREQ(2.4.2)

# Enable shared libraries if available, and static if they don't conflict.
LT_INIT
AC_SUBST([LIBTOOL_DEPS])

# Determine C++ compiler to use.
AC_PROG_CXX

# Enable sed for substitution.
AC_PROG_SED

# Compute the canonical host-system type variable host, including host_os.
AC_CANONICAL_HOST

# Enable silent rules option.
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# Check for pkg-config.
PKG_PROG_PKG_CONFIG
AS_IF([test -n "$PKG_CONFIG"], [],
    [AC_MSG_ERROR([pkg-config is required but was not found.])])

AS_CASE([${enable_static}],
    [yes], [AC_SUBST([PKG_CONFIG], ["$PKG_CONFIG --static"])],
    [])

# Declare environment variables that affect the build.
#------------------------------------------------------------------------------
AC_ARG_VAR([CC], "C compiler to use, such as gcc or clang")
AC_ARG_VAR([CXX], "C++ compiler to use, such as g++ or clang++")
AC_ARG_VAR([PKG_CONFIG_PATH], "Additional directories for package discovery.")

# Check for baseline language coverage in the compiler for the C++20 standard.
#------------------------------------------------------------------------------
AX_CXX_COMPILE_STDCXX([20], [noext], [mandatory])


# Process options.
#==============================================================================
# Implement --with-bash-completiondir and output ${bash_completiondir} and declare BASH_COMPLETIONDIR.
#------------------------------------------------------------------------------
AC_MSG_CHECKING([--with-bash-completiondir option])
AC_ARG_WITH([bash-completiondir],
    AS_HELP_STRING([--with-bash-completiondir[=DIR]],
        [Install bash completion support, optionally specifying the directory. This option may require elevated permissions. @<:@default=no@:>@]),
    [bash_completiondir=$withval],
    [bash_completiondir=no])
AC_MSG_RESULT([$bash_completiondir])
AC_SUBST([bash_completiondir])
AM_CONDITIONAL([BASH_COMPLETIONDIR], [test x$bash_completiondir != xno])

# Implement --with-pkgconfigdir and output ${pkgconfigdir}.
#------------------------------------------------------------------------------
AC_MSG_CHECKING([--with-pkgconfigdir option])
AC_ARG_WITH([pkgconfigdir],
    AS_HELP_STRING([--with-pkgconfigdir=DIR],
        [Path to pkgconfig directory. @<:@default=${libdir}/pkgconfig@:>@]),
    [pkgconfigdir=$withval],
    [pkgconfigdir=${libdir}/pkgconfig])
AC_MSG_RESULT([$pkgconfigdir])
AC_SUBST([pkgconfigdir])

# Implement --with-tests and declare WITH_TESTS.
#------------------------------------------------------------------------------
AC_MSG_CHECKING([--with-tests option])
AC_ARG_WITH([tests],
    AS_HELP_STRING([--with-tests],
        [Compile with unit tests. @<:@default=yes@:>@]),
    [with_tests=$withval],
    [with_tests=yes])
AC_MSG_RESULT([$with_tests])
AM_CONDITIONAL([WITH_TESTS], [test x$with_tests != xno])

# Implement --with-console and declare WITH_CONSOLE.
#------------------------------------------------------------------------------
AC_MSG_CHECKING([--with-console option])
AC_ARG_WITH([console],
    AS_HELP_STRING([--with-console],
        [Compile console application. @<:@default=yes@:>@]),
    [with_console=$withval],
    [with_console=yes])
AC_MSG_RESULT([$with_console])
AM_CONDITIONAL([WITH_CONSOLE], [test x$with_console != xno])

# Implement --enable-ndebug and define NDEBUG.
#------------------------------------------------------------------------------
AC_MSG_CHECKING([--enable-ndebug option])
AC_ARG_ENABLE([ndebug],
    AS_HELP_STRING([--enable-ndebug],
        [Compile without debug assertions. @<:@default=yes@:>@]),
    [enable_ndebug=$enableval],
    [enable_ndebug=yes])
AC_MSG_RESULT([$enable_ndebug])
AS_CASE([${enable_ndebug}], [yes], AC_DEFINE([NDEBUG]))

# Inherit --enable-shared and define BOOST_ALL_DYN_LINK.
#------------------------------------------------------------------------------
AS_CASE([${enable_shared}], [yes], AC_DEFINE([BOOST_ALL_DYN_LINK]))

# Implement --enable-isystem.
#------------------------------------------------------------------------------
AC_MSG_CHECKING([--enable-isystem option])
AC_ARG_ENABLE([isystem],
    AS_HELP_STRING([--enable-isystem],
        [Substitute -isystem for -I in dependencies. @<:@default=no@:>@]),
    [enable_isystem=$enableval],
    [enable_isystem=no])
AC_MSG_RESULT([$enable_isystem])


# Set flags.
#==============================================================================
# Require c++20 for all c++ products.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-std=c++20],
        [CXXFLAGS="$CXXFLAGS -std=c++20"])])

# Warn on all stuff.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wall],
        [CFLAGS="$CFLAGS -Wall"])])

# Warn on all stuff.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wall],
        [CXXFLAGS="$CXXFLAGS -Wall"])])

# Warn on extra stuff.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wextra],
        [CFLAGS="$CFLAGS -Wextra"])])

# Warn on extra stuff.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wextra],
        [CXXFLAGS="$CXXFLAGS -Wextra"])])

# Disallow warning on style order of declarations.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wno-reorder],
        [CXXFLAGS="$CXXFLAGS -Wno-reorder"])])

# Suppress warning for incomplete field initialization.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wno-missing-field-initializers],
        [CXXFLAGS="$CXXFLAGS -Wno-missing-field-initializers"])])

# Conform to style.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wno-missing-braces],
        [CXXFLAGS="$CXXFLAGS -Wno-missing-braces"])])

# Ignore comments within comments or commenting of backslash extended lines.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wno-comment],
        [CXXFLAGS="$CXXFLAGS -Wno-comment"])])

# Suppress warning for copy of implicitly generated copy constructor.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_COMPILE_FLAG([-Wno-deprecated-copy],
        [CXXFLAGS="$CXXFLAGS -Wno-deprecated-copy"])])

# Conflict in stdlib under clang. Enabled in clang only.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*clang*],
    [AX_CHECK_COMPILE_FLAG([-Wno-mismatched-tags],
        [CXXFLAGS="$CXXFLAGS -Wno-mismatched-tags"])])

# Address -undefined dynamic_lookup MacOS error.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_LINK_FLAG([-no_fixup_chains],
        [LDFLAGS="$LDFLAGS -no_fixup_chains"])])

# Protect stack.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_LINK_FLAG([-fstack-protector],
        [LDFLAGS="$LDFLAGS -fstack-protector"])])

# Protect stack comprehensively.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_CHECK_LINK_FLAG([-fstack-protector-all],
        [LDFLAGS="$LDFLAGS -fstack-protector-all"])])


# Check dependencies.
#==============================================================================
# Require Boost of at least version 1.86.0 and output ${boost_CPPFLAGS/LDFLAGS}.
#------------------------------------------------------------------------------
AS_CASE([${CC}], [*],
    [AX_BOOST_BASE([1.86.0],
        [AC_SUBST([boost_CPPFLAGS], [${BOOST_CPPFLAGS}])
         AC_SUBST([boost_ISYS_CPPFLAGS], [`echo ${BOOST_CPPFLAGS} | $SED s/^-I/-isystem/g | $SED s/' -I'/' -isystem'/g`])
         AC_SUBST([boost_LDFLAGS], [${BOOST_LDFLAGS}])
         AC_MSG_NOTICE([boost_CPPFLAGS : ${boost_CPPFLAGS}])
         AC_MSG_NOTICE([boost_ISYS_CPPFLAGS : ${boost_ISYS_CPPFLAGS}])
         AC_MSG_NOTICE([boost_LDFLAGS : ${boost_LDFLAGS}])],
        [AC_MSG_ERROR([Boost 1.86.0 or later is required but was not found.])])])

AS_CASE([${enable_isystem}],[yes],
    [AC_SUBST([boost_BUILD_CPPFLAGS], [${boost_ISYS_CPPFLAGS}])],
    [AC_SUBST([boost_BUILD_CPPFLAGS], [${boost_CPPFLAGS}])])

AC_MSG_NOTICE([boost_BUILD_CPPFLAGS : ${boost_BUILD_CPPFLAGS}])

AS_CASE([${with_tests}], [yes],
    [AX_BOOST_UNIT_TEST_FRAMEWORK
     AC_SUBST([boost_unit_test_framework_LIBS], [${BOOST_UNIT_TEST_FRAMEWORK_LIB}])
     AC_MSG_NOTICE([boost_unit_test_framework_LIBS : ${boost_unit_test_framework_LIBS}])],
    [AC_SUBST([boost_unit_test_framework_LIBS], [])])

# Require bash-completion of at least version 2.0.0 and output ${bash_completion_CPPFLAGS/LIBS/PKG}.
#------------------------------------------------------------------------------
AS_CASE([${bash_completiondir}], [yes],
    [PKG_CHECK_MODULES([bash_completion], [bash-completion >= 2.0.0],
        [bash_completion_INCLUDEDIR="`$PKG_CONFIG --variable=includedir "bash-completion >= 2.0.0" 2>/dev/null`"
         bash_completion_OTHER_CFLAGS="`$PKG_CONFIG --cflags-only-other "bash-completion >= 2.0.0" 2>/dev/null`"
         bash_completiondir="`$PKG_CONFIG --variable=completionsdir "bash-completion >= 2.0.0" 2>/dev/null`"],
        [bash_completion_INCLUDEDIR=""
         bash_completion_OTHER_CFLAGS=""
         bash_completiondir="${datadir}/bash-completion/completions"])
     AC_SUBST([bash_completion_PKG], ['bash-completion >= 2.0.0'])
     AC_SUBST([bash_completion_CPPFLAGS], [${bash_completion_CFLAGS}])
     AS_IF([test x${bash_completion_INCLUDEDIR} != "x"],
        [AC_SUBST([bash_completion_ISYS_CPPFLAGS], ["-isystem${bash_completion_INCLUDEDIR} ${bash_completion_OTHER_CFLAGS}"])],
        [AC_SUBST([bash_completion_ISYS_CPPFLAGS], [${bash_completion_OTHER_CFLAGS}])])
     AC_MSG_NOTICE([bash_completion_CPPFLAGS : ${bash_completion_CPPFLAGS}])
     AC_MSG_NOTICE([bash_completion_ISYS_CPPFLAGS : ${bash_completion_ISYS_CPPFLAGS}])
     AC_MSG_NOTICE([bash_completion_OTHER_CFLAGS : ${bash_completion_OTHER_CFLAGS}])
     AC_MSG_NOTICE([bash_completion_INCLUDEDIR : ${bash_completion_INCLUDEDIR}])
     AC_MSG_NOTICE([bash_completion_LIBS : ${bash_completion_LIBS}])],
    [AC_SUBST([bash_completion_PKG], [])])

AS_CASE([${enable_isystem}],[yes],
    [AC_SUBST([bash_completion_BUILD_CPPFLAGS], [${bash_completion_ISYS_CPPFLAGS}])],
    [AC_SUBST([bash_completion_BUILD_CPPFLAGS], [${bash_completion_CPPFLAGS}])])

AC_MSG_NOTICE([bash_completion_BUILD_CPPFLAGS : ${bash_completion_BUILD_CPPFLAGS}])

# Require bitcoin-node of at least version 4.0.0 and output ${bitcoin_node_CPPFLAGS/LIBS/PKG}.
#------------------------------------------------------------------------------
PKG_CHECK_MODULES([bitcoin_node], [libbitcoin-node >= 4.0.0],
    [bitcoin_node_INCLUDEDIR="`$PKG_CONFIG --variable=includedir "libbitcoin-node >= 4.0.0" 2>/dev/null`"
     bitcoin_node_OTHER_CFLAGS="`$PKG_CONFIG --cflags-only-other "libbitcoin-node >= 4.0.0" 2>/dev/null`"],
    [AC_MSG_ERROR([libbitcoin-node >= 4.0.0 is required but was not found.])])
AC_SUBST([bitcoin_node_PKG], ['libbitcoin-node >= 4.0.0'])
AC_SUBST([bitcoin_node_CPPFLAGS], [${bitcoin_node_CFLAGS}])
AS_IF([test x${bitcoin_node_INCLUDEDIR} != "x"],
    [AC_SUBST([bitcoin_node_ISYS_CPPFLAGS], ["-isystem${bitcoin_node_INCLUDEDIR} ${bitcoin_node_OTHER_CFLAGS}"])],
    [AC_SUBST([bitcoin_node_ISYS_CPPFLAGS], [${bitcoin_node_OTHER_CFLAGS}])])
AC_MSG_NOTICE([bitcoin_node_CPPFLAGS : ${bitcoin_node_CPPFLAGS}])
AC_MSG_NOTICE([bitcoin_node_ISYS_CPPFLAGS : ${bitcoin_node_ISYS_CPPFLAGS}])
AC_MSG_NOTICE([bitcoin_node_OTHER_CFLAGS : ${bitcoin_node_OTHER_CFLAGS}])
AC_MSG_NOTICE([bitcoin_node_INCLUDEDIR : ${bitcoin_node_INCLUDEDIR}])
AC_MSG_NOTICE([bitcoin_node_LIBS : ${bitcoin_node_LIBS}])

AS_CASE([${enable_isystem}],[yes],
    [AC_SUBST([bitcoin_node_BUILD_CPPFLAGS], [${bitcoin_node_ISYS_CPPFLAGS}])],
    [AC_SUBST([bitcoin_node_BUILD_CPPFLAGS], [${bitcoin_node_CPPFLAGS}])])

AC_MSG_NOTICE([bitcoin_node_BUILD_CPPFLAGS : ${bitcoin_node_BUILD_CPPFLAGS}])

# Require bitcoin-protocol of at least version 4.0.0 and output ${bitcoin_protocol_CPPFLAGS/LIBS/PKG}.
#------------------------------------------------------------------------------
PKG_CHECK_MODULES([bitcoin_protocol], [libbitcoin-protocol >= 4.0.0],
    [bitcoin_protocol_INCLUDEDIR="`$PKG_CONFIG --variable=includedir "libbitcoin-protocol >= 4.0.0" 2>/dev/null`"
     bitcoin_protocol_OTHER_CFLAGS="`$PKG_CONFIG --cflags-only-other "libbitcoin-protocol >= 4.0.0" 2>/dev/null`"],
    [AC_MSG_ERROR([libbitcoin-protocol >= 4.0.0 is required but was not found.])])
AC_SUBST([bitcoin_protocol_PKG], ['libbitcoin-protocol >= 4.0.0'])
AC_SUBST([bitcoin_protocol_CPPFLAGS], [${bitcoin_protocol_CFLAGS}])
AS_IF([test x${bitcoin_protocol_INCLUDEDIR} != "x"],
    [AC_SUBST([bitcoin_protocol_ISYS_CPPFLAGS], ["-isystem${bitcoin_protocol_INCLUDEDIR} ${bitcoin_protocol_OTHER_CFLAGS}"])],
    [AC_SUBST([bitcoin_protocol_ISYS_CPPFLAGS], [${bitcoin_protocol_OTHER_CFLAGS}])])
AC_MSG_NOTICE([bitcoin_protocol_CPPFLAGS : ${bitcoin_protocol_CPPFLAGS}])
AC_MSG_NOTICE([bitcoin_protocol_ISYS_CPPFLAGS : ${bitcoin_protocol_ISYS_CPPFLAGS}])
AC_MSG_NOTICE([bitcoin_protocol_OTHER_CFLAGS : ${bitcoin_protocol_OTHER_CFLAGS}])
AC_MSG_NOTICE([bitcoin_protocol_INCLUDEDIR : ${bitcoin_protocol_INCLUDEDIR}])
AC_MSG_NOTICE([bitcoin_protocol_LIBS : ${bitcoin_protocol_LIBS}])

AS_CASE([${enable_isystem}],[yes],
    [AC_SUBST([bitcoin_protocol_BUILD_CPPFLAGS], [${bitcoin_protocol_ISYS_CPPFLAGS}])],
    [AC_SUBST([bitcoin_protocol_BUILD_CPPFLAGS], [${bitcoin_protocol_CPPFLAGS}])])

AC_MSG_NOTICE([bitcoin_protocol_BUILD_CPPFLAGS : ${bitcoin_protocol_BUILD_CPPFLAGS}])


# Process outputs into templates.
#==============================================================================
AC_CONFIG_FILES([Makefile libbitcoin-server.pc])
AC_OUTPUT
