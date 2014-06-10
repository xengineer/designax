# -*- encoding : utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

State.create(state: '構図')
State.create(state: 'ラフ')
State.create(state: '線画')
State.create(state: '着色')
State.create(state: '上位')
State.create(state: '反転')
State.create(state: '色替')
State.create(state: '納品済')

CorpState.create(state: '未確認')
CorpState.create(state: 'OK')
CorpState.create(state: 'RE')

Project.create(project_name: 'SG')
Project.create(project_name: 'SG2')

UserGroup.create(name: 'Nubee')
UserGroup.create(name: 'NubeeTest')
