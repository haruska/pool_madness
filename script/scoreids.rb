require 'open-uri'

def parsed
  @parsed ||= JSON::parse(open('http://scores.pool-madness.com:8888/index.json').read)
end

def parsed_find(str)
  par = parsed.select {|x| x['home_team']['full_name'] =~ /#{str}/ || x['away_team']['full_name'] =~ /#{str}/}

  ret = {}
  par.each do |x| 
    ret[ x['home_team']['full_name'] ] = x['home_team']['team_id']
    ret[ x['away_team']['full_name'] ] = x['away_team']['team_id']
  end
  ret
end

def update_team(str, score_id)
  team = Team.find_by_name str
  team.score_team_id = score_id
  team.save
end

