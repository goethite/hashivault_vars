#!/usr/bin/python

from __future__ import print_function
import atexit
import os
import sys
import inspect
from setuptools import setup

from setuptools.command.install import install

PKGNAME = "hashivault_vars"
ANSIBLE_VARS = "/usr/local/lib/python2.7/dist-packages/ansible/plugins/vars"
MODLINK = os.path.join(ANSIBLE_VARS, PKGNAME + ".py")


class CustomInstall(install):
    def run(self):
        def _post_install():
            if os.getuid() != 0:
                return

            def find_module_path():
                for p in sys.path:
                    if os.path.isdir(p) and PKGNAME in os.listdir(p):
                        return os.path.join(p, PKGNAME)
            install_path = find_module_path()

            if os.path.exists(ANSIBLE_VARS):

                if os.path.exists(MODLINK):
                    if os.path.islink(MODLINK):
                        os.unlink(MODLINK)
                    else:
                        raise Exception(
                            "%s already exists and is not a symlink" % (
                                MODLINK)
                        )

                # Link Ansible vars plugins to this module
                os.symlink(
                    os.path.join(install_path, PKGNAME + ".py"),
                    MODLINK
                )

        atexit.register(_post_install)
        install.run(self)


__location__ = os.path.join(os.getcwd(), os.path.dirname(
    inspect.getfile(inspect.currentframe())))

setup(
    cmdclass={'install': CustomInstall},
    name=PKGNAME,
    version="0.2.0",
    packages=[PKGNAME],
    install_requires=["urllib3", "hvac"]
)
