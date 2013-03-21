#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__) ,  '..' ,  'config' ,  'environment'))

data = {
'Akron' => 33,
'Albany' => 141,
'Arizona' => 58,
'Belmont' => 150,
'Bucknell' => 144,
'Butler' => 16,
'California' => 132,
'Cincinnati' => 90,
'Colorado' => 91,
'Colorado St' => 77,
'Creighton' => 152,
'Davidson' => 147,
'Duke' => 39,
'Fla Gulf Coast' => 154,
'Florida' => 89,
'Georgetown' => 37,
'Gonzaga' => 148,
'Harvard' => 151,
'Illinois' => 2,
'Indiana' => 9,
'Iona' => 155,
'Iowa St' => 44,
'JMU' => 153,
'Kansas' => 45,
'Kansas St' => 73,
'La Salle' => 15,
'Louisville' => 67,
'Marquette' => 133,
'Memphis' => 29,
'Miami (FL)' => 87,
'Michigan' => 1,
'Michigan St' => 12,
'Minnesota' => 3,
'Missouri' => 74,
'Montana' => 71,
'N Carolina' => 63,
'NC A&T' => 47,
'NC State' => 13,
'New Mexico' => 54,
'New Mex St' => 57,
'Notre Dame' => 66,
'NW State' => 49,
'Ohio St' => 31,
'Oklahoma' => 96,
'Oklahoma St' => 72,
'Ole Miss' => 75,
'Oregon' => 81,
'Pacific' => 83,
'Pittsburgh' => 101,
'San Diego St' => 55,
'S Dakota St' => 149,
'Southern U' => 53,
'St Louis' => 84,
"St Mary's" => 146,
'Syracuse' => 36,
'Temple' => 65,
'UCLA' => 59,
'UNLV' => 76,
'Valparaiso' => 143,
'VCU' => 35,
'Villanova' => 119,
'Wichita St' => 145,
'Wisconsin' => 10,
'W Kentucky' => 157
}


data.each do |name, team_id|
  team = Team.find_by_name(name)
  if team.present?
    team.score_team_id = team_id
    team.save!
  end
end

Team.all.each do |team|
  if team.score_team_id.blank?
    puts "#{team.name} missing a score team id"
  end
end