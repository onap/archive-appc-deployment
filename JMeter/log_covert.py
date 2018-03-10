#! /usr/bin/env python

<!--
============LICENSE_START==========================================
ONAP : APPC
===================================================================
Copyright (C) 2017-2018 AT&T Intellectual Property. All rights reserved.
===================================================================

Unless otherwise specified, all software contained herein is licensed
under the Apache License, Version 2.0 (the License);
you may not use this software except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

ECOMP is a trademark and service mark of AT&T Intellectual Property.
============LICENSE_END============================================
-->

#### Command line arguments
import argparse
parser = argparse.ArgumentParser(description="Convert delimited file from one delimiter to another; defaults to converting pipe-delimited to CSV.")
parser.add_argument("--delim-input", action="store", dest="delim_in", default="|", required=False, help="Input file delimiter; pipe is default (|)", nargs='?', metavar="'|'")
parser.add_argument("--delim-output", action="store", dest="delim_out", default=",", required=False, help="Output file delimiter; comma is default (,)", nargs='?', metavar="','")
parser.add_argument("--remove-line-char", action="store_true", dest="remove_line_char", default=False, help="remove \\n and \\r characters in fields and replace with spaces")
parser.add_argument("--quote-char", action="store", dest="quote_char", default='"', required=False, help="quote character; defaults to double quote (\")", nargs='?', metavar="\"")
parser.add_argument("-i", "--input", action="store", dest="input", required=False, help="input file; if not specified, take from standard input.", nargs='?', metavar="file.csv")
parser.add_argument("-o", "--output", action="store", dest="output", required=False, help="output file; if not specified, write to standard output", nargs='?', metavar="file.pipe")
parser.add_argument("-v", "--verbose", action="store_true", dest="verbose", default=False, help="increase verbosity")
args  =  parser.parse_args()

# Conversion for logs begins here.
import argparse
import csv
import sys

if args.input:
    file_reader = file.reader(open(args.input, 'rb'), delimiter=args.dlm_in, quotechar=args.quote_char)
else:
    file_reader = file.reader(sys.stdin, delimiter=args.dlm_in, quotechar=args.quote_char)

if args.output:
    h_outfile = open(args.output, 'wb')
else:
    h_outfile = sys.stdout

for row in file_reader:
    row = args.dlm_out.join(row)
    if args.remove_line_char:
        row  =  row.replace('\n', ' ').replace('\r', ' ')
    h_outfile.write("%s\n" % (row))
    h_outfile.flush()