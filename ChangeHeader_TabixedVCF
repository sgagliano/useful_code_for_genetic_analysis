#DESCRIPTION
#Use tabix to add a header to a bgzipped and tabixed file (e.g. my_file.vcf.gz)

tabix -H my_file_with_header.vcf.gz > new_header.txt
tabix -r new_header.txt my_file.vcf.gz | bgzip -c > my_file-withHead.vcf.gz
