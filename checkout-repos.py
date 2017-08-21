#!/usr/bin/python

import os

from git import Git

DEFAULT_BRANCH = "origin/master"
YOCTO_RELEASE = "pyro"

yocto = {
	'base_url': "git://git.yoctoproject.org/",
	'name': "poky",
	'branch': YOCTO_RELEASE
}

layers = [
{
	'base_url': "https://github.com/agherzan/",
	'name': "meta-raspberrypi",
	'branch': YOCTO_RELEASE
},
{
	'base_url': "https://github.com/openembedded/",
	'name': "meta-openembedded",
	'branch': YOCTO_RELEASE
},
{
	'base_url': "git@github.com:j-be/",
	'name': "meta-vj",
	'branch': YOCTO_RELEASE
}
]


def cloneOrCheckout(base_path, repo):
	git = Git()
	repo_path = os.path.join(base_path, repo['name'])
	print (repo_path)
	try:
		os.chdir(repo_path)
	except OSError:
		os.chdir(base_path)
		git.clone(repo['base_url'] + repo['name'])
		os.chdir(repo_path)
		cloned = True
	finally:
		git.fetch()
		git.checkout(repo['branch'])
		os.chdir(base_path)



startPath = os.getcwd()
cloneOrCheckout(startPath, yocto)
yocto_path = os.path.join(startPath, yocto['name'])

for repo in layers:
	cloneOrCheckout(yocto_path, repo)
