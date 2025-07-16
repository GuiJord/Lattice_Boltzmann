cd .. 

mkdir lesc_boltz

rsync -av --exclude 'testset' --exclude 'venv' new_organized_code/ lesc_boltz/

scp -r lesc_boltz lesc:~/guilherme/