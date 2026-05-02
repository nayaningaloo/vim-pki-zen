# vim-pki-zen

## Description

Actually this plugin will make working with CA Bundles smarter.

### CA-Bundle Dashboard
In best it will provide a structured humanreadable index
to have a 'vim-ca-bundle-audit-dashboard' for daily work.
This will be done by extracting the information from certificate
via openssl and rewrite of the foldtext.


What you might expect to see in foldtext:

- Status/Validity Information `[ !EXP ]` or `[  OK  ]`
  - On Error `[ ?ERR ]`
- Subject `S: _extracted subject of certificate_`
- Issuer `I: _extracted subject of certificate_`
- Valid until date `Exp: _ISO-DATE Format_`


It is actually not possible to search in the dashboard.
The foldtext is not recognized by Vim for search.


#### Features
- less dependencies: Vim and OpenSSL
- Lazy Loading
- Buffed Scan
- no tempfiles used
- efficient data extraction
  - uses openssl as expected to be installed
- no use of date for compability/portability
  - ISO converting via vim directory to have comparable dateformat
  - the actual date will be fetched via `strftime('%Y%m%d')`
- use `printf` for columsetups (noisecanceling)
- classic vim script - it will run on modern and on older systems as well
- Keymaps for converting the PEM to text on folds


#### Roadmap - Future Tasks
- CRL-Check
  Check Serial against local CRL to check if it is revoked and
  needs also to be flagged - maybe REV or REVOKED
- Visual warnsystem
  - expired certificates will catch attention -
    if everything will work out, expiered certificate is colored in red
    and valid in green lines, but acutally it's blocked by Folded - maybe
    I'll find a way to trick it out. Usage of ANSII Codes is out of scope
    because of portability reasons at the moment.
- Smart Sorting - Sort certificates by expire date

## Recommendations
### Installation
Use vim-pathogen plugin. This is easy to use. But there are several ways
to install the plugin to use it in Vim.

On debian install it via apt:
```
apt install vim-pathogen
```

## Usage
Copy the vim-pem-plugin folder to your ~/.vim/bundle/ directory.

Add following lines to your .vimrc

```
execute pathogen#infect()

" enable plugin
let g:pkizen_enabled = 1
" disable  plugin
let g:pkizen_enabled = 0

" Keymaps - smart converting
:nmap dox V:!openssl x509 -text<ENTER>zM
:xmap dox V:!openssl x509 -text<ENTER>zM
```

## Examples
Open a certificate file or certificate bundle in vim, for example
`/etc/ssl/certs/ca-certificates.crt`



## Philosophy
## Why KISS and Vim-Script Still rule

In an era of bloated electron apps and AI-heavy editor that consume gigabytes
of RAM just to open a text file, a lightweight Vim script is more than just
a tool - it is an act of engineering rebillion. This project is build on the
belief that software shouldn't get in your way.

### 1. Low Latency of Thought

Modern IDEs feel like cockpits in a commercial airliner - cluttert with
switches and background processes. A Vim script following the KISS (Keep it
Simple Stupid) principle is like a hand-forged blade. There is no abstraction
layer between your thought and the execution. It's fact, immediate, and uses
virtually zero resources.

### 2. Longevity through Transparency

Software "bloat" often leads to bit rot. While modern frameworks break every
few years, a clean Vim script is nearly immortal.
KISS means that if something breaks, you can fix it in five minutes because
you aren't digging through thousands of dependencies. You own the tool; the
tool doesn't own you.

### 3. The Power of Unix Composition

Instead of reinventing the wheel, this plugin follow the classic Unix
philosophy: Do one thing and do it well. By bridging the raw power of
openssl with Vim's native folding, it achieves more with a few lines of code
than a monolithic application does with 50k lines. It's about composition,
not complexity.

### 4. Survival-Grade Portability

This script doesn't need an internet connection, an npm install, or an API
key. It works on a high-end workstation as well as on a remote, minimal
server via SSH. It is the "cockroach of IT" - designed to survive and
perform in any environment. (It should, I've only tested on local machine).


### 5. The Aesthetics of the Essential

There is a deep satisfaction in solving a complex problem with surgical
precision. This plugin is proof that you don't need a massive footprint
to build a functional dashboard. You just need a solid idea and a bit of
Vim-Voodoo,

"Minimalism isn't about lack of features; it's about the abundance of focus"

## History
The first plugin was build in 2015 to fold cert bundles and or text-files.
As time went by, I thought there might be some improvments possible, to
get more visibility in CA-Bundles.
Now I know better what real world tasks might need and have better
understanging for the wish for such a plugin.

## Vision
During this improvment, there came up some thoughts regarding additional
improvments, for example  the possibility to create CSR directly from an
opened certificate file, that needs to be renewed.
Therefore I'll release it now under vim-pki-zen.

## LICENSE
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Full [GPLv3](./LICENSE).
