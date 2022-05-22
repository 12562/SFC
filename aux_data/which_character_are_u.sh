#!/bin/bash

end_point_url="https://www.mooc.e-yantra.org/which-character-are-u"

get_character_img_url=$(curl -X POST -H "Content-Type: application/json" -d '{"username":"mohit12562@gmail.com", "password":"UHTozJhd"}' ${end_point_url})
get_character_img_url=$(echo "$get_character_img_url" | sed 's/\&.*//')
echo "$get_character_img_url"

get_ascii_txt_from_img=$(curl https://img2txt.genzouw.com?url=${get_character_img_url})
echo "$get_ascii_txt_from_img" > img2ascii_output.txt
cat img2ascii_output.txt
