Jupyter

**on the cluster**

`pip install jupyter`

`pip install <any other packages you may need>`

`source ~/miniconda2/bin/activate jupyter`

###### on cluster, preferable in directory where your code is

`jupyter notebook --no-browser --port 9876`

###### You can use any port you want. jupyter might fail to start if port is used by some other program. If this happens, then just try out any other number. Don’t use well known port such as 20,22,80,5000 and similar. Port number can go up to ~65000

**on your personal computer's terminal**

`ssh -v -N -L 9876:localhost:9876 username@cluster_ip_address` 

###### If port was not already in use on you local machine, then you should see a message like 'Local forwarding listening on 127.0.0.1 port 9876.’. If you see a message like 'Could not request local forwarding.’, then try another port.

#in web browser on personal computer

`localhost:9876`

###### make a ipynb into an HTML

`jupyter nbconvert --execute --ExecutePreprocessor.timeout=43200 --to HTML --template my_file.ipynb --output Outname_name`
