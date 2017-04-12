# -*- mode: python -*-
import sys
import os

block_cipher = None

added_files = [
    ('lib',''),
    ('gui',''),
    ('plugins',''),
    ('packages','')
    ]

a = Analysis(['electrum-dash', 'gui/qt/main_window.py', 'gui/text.py',
              'lib/util.py', 'lib/wallet.py', 'lib/simple_config.py',
              'lib/bitcoin.py','lib/interface.py', 'lib/dnssec.py',
              'plugins/trezor/trezor.py','gui/qt/installwizard.py',
              ],
             pathex=[os.path.dirname(os.path.realpath('__file__'))],
             binaries=[],
             datas=added_files,
             hiddenimports=['PyQt4','PyQt4.QtCore', 'PyQt4.QtGui', 'PyQt4.QtWebKit', 'PyQt4.QtNetwork','lib','gui','plugins','trezorlib','hid','sip', 'csv', 'x11_hash'],
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
          name='electrum-dash.bin',
          debug=False,
          strip=False,
          upx=False,
          console=False , icon='electrum-dash.icns')
app = BUNDLE(exe,
             name='electrum-dash.app',
             icon='electrum-dash.icns',
             bundle_identifier=None)
