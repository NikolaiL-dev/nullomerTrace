from argparse import ArgumentParser
from pathlib import Path
from sys import exit
import requests

path2root = Path(__file__).parent.parent

parser = ArgumentParser(description='The script downloads a genomes setted in the config.tsv file.' +\
                                             'You can set up list of target genome if you edit the file.')

parser.add_argument('--input', '-i', default=path2root.joinpath("genomes", "config.tsv"), type=str, required=False,
                    help='Path to the config.tsv file contained names of local files & urls.')
                    
parser.add_argument('--output', '-o', default=path2root.joinpath("genomes"), type=str, required=False,
                    help='Path to the directory where genome files will be saved.')

parser.add_argument('--listed', '-l', action='store_true',
                    help='To print the list of target genomes in config.tsv & terminate program.')

if __name__ == '__main__':
    args = parser.parse_args()
    
    for _args, _path in zip(["--input/-i", "--output/-o"], [args.input, args.output]):
        if not Path(_path).exists():
            raise ValueError(f"Path {_path} does not exist. You should check argument {_args}.") 
    with open(args.input) as f:
        filenames, urls = [], []
        for line in f:
            line = line.strip()
            if line.startswith("#") or len(line) == 0: continue
            line = line.split("\t")
            filenames.append(line[0])
            urls.append(line[1])
                
    if args.listed:
        for filename, url in zip(filenames, urls):
            print(f">>> {filename}", url, sep='\t', end='\n\n')
        exit(0)
        
    for filename, url in zip(filenames, urls):
        print(f"The '{filename}' from {url} is being downloaded.")
        response = requests.get(url, stream=True) 

        if response.status_code == 200:
            path2output = Path(args.output).joinpath(filename)
            with open(path2output, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            print(f"File '{filename}' is downloaded successfully.")
        else:
            print(f"Error: Could not download file. Status code: {response.status_code}")
