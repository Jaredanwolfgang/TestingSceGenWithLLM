import sys
import os
import argparse
import json
import re
import tokenize
from io import BytesIO

def convert_file(in_file_name, output_dir):
    base_file_name = os.path.splitext(os.path.basename(in_file_name))[0]
    out_file_name = os.path.join(output_dir, base_file_name + ".json")
    with open(in_file_name) as in_fs:
        lines = in_fs.readlines()
        
    text_str = "".join(lines)
    tokens = list(tokenize.tokenize(BytesIO(text_str.encode('utf-8')).readline))
    # print(tokens)
    docstring = None
    if tokens[1].type == 3:
        docstring = tokens[1].string
    
    out_dict = {"docstring" : docstring,
                "has_docstring" : docstring is not None,
                "map_and_model" : None,
                "constants" : None,
                "monitors" : None,
                "behaviors" : None,
                "spatial_relations" : None,
                "scenario" : None,
                "name" : base_file_name}

    current_doc = None
    line = 1
    for token in tokens:
        if token.type == tokenize.COMMENT: # Comment Type
            if "map" in token.string.lower():
                current_doc = "map_and_model"
            elif "constants" in token.string.lower():
                current_doc = "constants"
            elif "monitors" in token.string.lower():
                current_doc = "monitors"
            elif "behaviors" in token.string.lower():
                current_doc = "behaviors"
            elif "spatial relations" in token.string.lower():
                current_doc = "spatial_relations"
            elif "scenario" in token.string.lower():
                current_doc = "scenario"
        else:
            if current_doc is not None and out_dict[current_doc] is not None and token.start[0] != line:
                out_dict[current_doc] += token.line
            elif current_doc is not None and out_dict[current_doc] is None and token.start[0] != line:
                out_dict[current_doc] = token.string
        line = token.end[0]

    with open(out_file_name, "w") as out_fs:
        json.dump(out_dict, out_fs, indent=2)

def main():
    arg_parser = argparse.ArgumentParser(description = 'Collect Scenic scenarios and encode them as json files')
    arg_parser.add_argument("files", type=str, nargs='+',
                            help=".scenic files to be converted")
    arg_parser.add_argument("-d", "--output-dir", type=str, required=False, default="./",
                            help="Output directory (default: ./)")

    args = arg_parser.parse_args()
    for in_file_name in args.files:
        convert_file(in_file_name, args.output_dir)

if __name__ == "__main__":
    main()
