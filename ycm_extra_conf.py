"""Python interpreter discovery for YouCompleteMe.

This file intentionally follows the same workspace environment that shell tools
use: prefer the nearest .envrc, then fall back to a nearby virtualenv.
"""

from __future__ import annotations

import functools
import os
import subprocess
from typing import Any


_VIMHOME = os.path.abspath(os.path.dirname(__file__))
_ENV_LAUNCHER = os.path.join(_VIMHOME, "bin", "python-project-env")


@functools.lru_cache(maxsize=256)
def _launcher_value(mode: str, filename: str) -> str:
    try:
        return subprocess.check_output(
            [_ENV_LAUNCHER, mode, filename],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return ""


def Settings(**kwargs: Any) -> dict[str, str]:
    filename = kwargs.get("filename")
    if not isinstance(filename, str):
        return {}

    settings = {}

    interpreter_path = _launcher_value("--print-python", filename)
    if interpreter_path:
        settings["interpreter_path"] = interpreter_path

    project_directory = _launcher_value("--print-project-root", filename)
    if project_directory:
        settings["project_directory"] = project_directory

    return settings
