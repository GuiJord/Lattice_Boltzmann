cd .. 

#date
date_="$(date +%Y_%m_%d)"

#backup folder name
folder=$"BACKUP_${date_}"

#create folder
mkdir $folder

#copy content excluding virtual environment and tests
rsync -av --exclude 'testset' --exclude '.venv' ic_lbm/ --exclude '.git' --exclude *.png --exclude *.dat --exclude *.npy $folder

#sending a copy to a windows folder just in case
cp -r "$folder" "$(cat windows_folder_path)"
#to do a Backup in cloud use \\wsl.localhost\Ubuntu-22.04 to locate the file in the file explorer