from io import BytesIO
import requests
import tarfile
import shutil
import copy
import gzip
import sys
import os


API_BASE = "https://api.anaconda.org"


def download(owner, pkg, ver, base, dst):
    with requests.get("{}/download/{}/{}/{}/{}".format(API_BASE, owner, pkg, ver, base)) as resp:
        resp.raise_for_status()
        with tarfile.open(fileobj=BytesIO(resp.content), mode="r:bz2") as tar:
            name, = [n for n in tar.getnames() if n.startswith("bin/sqm")]
            with tar.open(dst, "w:gz") as dst:
                src = tar.extractfile(name)
                info = tar.getmember(name)
                info.name = os.path.basename(name)
                dst.addfile(info, src)


vendor = {
    "osx": "apple",
    "win": "pc",
}


def main():
    _, ver, dst = sys.argv
    owner = "mordred-descriptor"
    pkg = "sqm"

    with requests.get("https://api.anaconda.org/release/{}/{}/{}".format(owner, pkg, ver)) as resp:
        resp.raise_for_status()
        for dist in resp.json()['distributions']:
            out_name = "sqm-{}-{}-{}-{}.tar.gz".format(
                dist["version"],
                dist["attrs"]["machine"],
                vendor.get(dist["attrs"]["platform"], "unknown"),
                dist["attrs"]["subdir"].replace("-", ""),
                )
            print("downloading {}...".format(out_name))
            download(owner, pkg, ver, dist["basename"], os.path.join(dst, out_name))


if __name__ == "__main__":
    main()
