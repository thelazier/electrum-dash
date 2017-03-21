# -*- mode: python -*-
import sys
import os

block_cipher = None

added_files = [
    ('lib',''),
    ('gui',''),
    ('plugins','')
    ]

a = Analysis(['electrum-dash'],
             pathex=[os.path.dirname(os.path.realpath('__file__'))],
             binaries=[],
             datas=added_files,
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='electrum-dash',
          debug=False,
          strip=False,
          upx=False,
          console=False , icon='electrum-dash.icns')
app = BUNDLE(exe,
             name='electrum-dash.app',
             icon='electrum-dash.icns',
             bundle_identifier=None)
