# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

districts_facilities = {
    'Boffa' => {
      facilities: [
        'Hopital',
        'CSU',
        'Colia',
        'Douprou',
        'Mankountan',
        'Tougnifily',
        'Koba',
        'Tamita',
        ['Lisso', 'Liss0'] 
      ]
    },
    'Boke' => {
      facilities: [
        ['Hopital', 'Boke'],
        'Bintimodia',
        'Correrah',
        'Dabiss',
        'Dibia',
        ['Kanfarandé', 'Kanfarande'],
        'Kassopo',
        'Kayenguissa',
        'Kollabui',
        'Koulifanya',
        'Malapouya',
        'Sangaredi',
        'Sansale',
        'Tanene'
      ]
    },
    'Coyah' => {
      facilities: [
        'Hopital',
        ['Fily', 'CS Fily'],
        ['Doumbouyah', 'CS Doumbouyah'],
        ['Maneah', 'CS Maneah'],
        ['Kouriah', 'CS Kouriah'],
        ['Wonkifong', 'CS Wonkifong']
      ]
    },
    'Dixinn' => {
      facilities: [
        'Macire',
        ['Hafia', 'CS Hafia'],
        ['Hopital Dixinn', 'Dixinn'],
        'CMC Miniere',
        'FMG',
        'CMA Dixinn',
        'Koundian',
        'Kondianakoro',
        'Balandougouba',
        'Sansando',
        'Niantanina',
        'Saladou'
      ]
    },
    'Dinguiraye' => {
      facilities: [
        'CSU Dinguiraye',
        ['Sélouma', 'Selouma'],
        'Kalinko',
        'Dialakoro',
        ['Diatifèrè', 'Diatifere'],
        'Lansanaya',
        "M'bonet",
        'Gagnakaly',
        ['Hôpital Dinguiraye', 'Hopital Dinguiraye', 'Hopital']
      ]
    },
    'Dubreka' => {
      facilities: [
        'Hopital',
        ['Khorira', 'CS Khorira'],
        'CSU',
        ['Ouassou', 'CS Ouassou'],
        ['Falessade', 'CS Falessade'],
        ['Tanene', 'CS Tanene'],
        ['Kondeyah', 'CS Kondeyah'],
        'CMC Kondeyah',
        ['Bady', 'CS Bady'],
        ['Tondon', 'CS Tondon']
      ]
    },
    'Fodecariyah' => {
      facilities: [
        ['Hopital', 'Hoipital'],
        'Bassia',
        ['Maférinyah', 'Maferinyah'],
        ['Farmoréah ', 'Farmoreah'],
        'Bokariah',
        'Kakossa',
        'Moussayah',
        'Benty',
        ['CSU', 'C S U'],
        'Sikhourou',
        'Kaback'
      ]
    },
    'Fria' => {
      facilities: [
        ['Hopital', 'Hôpital'],
        ['Sabende', 'CS Sabende'],
        'Aviation',
        ['Tormelin', 'CS Tormelin'],
        'Baguinet',
        ['Banguigny', 'CS Banguigny'],
        ['Tabossy', 'CS Tabossy']
      ]
    },
    'Gaoual' => {
      facilities: [
        'Hopital',
        'CSU',
        'Touba',
        'Kakoni',
        'Foulamori',
        'Malanta',
        'Kounsitel',
        'Wendou Mbour',
        'Koumbia'
      ]
    },
    'Kaloum' => {
      facilities: [
        ['Koulewondy', 'CS Koulewondy'],
        ['Boulbinet', 'CS Boulbinet'],
        ['Kassa', 'CS Kassa'],
        ['Port', 'CS Port'],
        'CMC Bernard Chouchner'
      ]
    },
    'Koundara' => {
      facilities: [
        'Hopital',
        'Sareboido',
        'Termesse',
        'Guingan',
        'Youkounkoun',
        'Sambailo',
        'Kamaby',
        'CSU'
      ]
    },
    'Koubia' => {
      facilities: [
        ['Hopital', 'HP'],
        'CSU',
        'Fafaya',
        'Gadha Woundou',
        'Matakaou',
        'Missira',
        'Pilimini'
      ]
    },
    'Labe' => {
      facilities: [
        ['Hopital', 'H RL'],
        'Bowloko',
        'Daka',
        'Dalein',
        ['Dara Labé', 'Dara Labe'],
        'Diari',
        'Dionfo',
        ['Fafabhé', 'Fafabhe'],
        ['Garambé', 'Garambe'],
        'Hafia',
        'Kalan',
        'Kourmangui',
        ['Leysaré', 'Leysare'],
        'Lombona',
        'Pellel',
        'Popodra',
        'Sannou',
        'Tountouroun',
        'CCS Noussy',

      ]
    },
    'Lelouma' => {
      facilities: [
        ['Hopital', 'LELOUMA'], 
        'CSU', 
        'Balaya', 
        'Sagale', 
        'Herico', 
        'Parawol', 
        'Korbe', 
        'Diountou', 
        'Lafou', 
        'Thianguel Bori', 
        'Manda Saran', 
        'Linsan'
      ]
    },
    'Matam' => {
      facilities: [
        'Hopital',
        'Matam',
        'Coleah',
        'Madina',
        'Baptiste',
        'Kalima'
      ]
    },
    'Matoto' => {
      facilities: [
        'Tombolia',
        'Matoto',
        'Tanene',
        'Yimbaya',
        'Dabompa',
        ['Gbessia Port 1', 'Gbessia Port1'],
        'Saint Gabriel',
        'Bernay Fotoba',
        ['CSA Siloe', 'C SA Siloe']
      ]
    },
    'Mali' => {
      facilities: [
        'Hopital', 
        ['CSU', 'CSU Mali'], 
        'Balaki', 
        'Donghel Sigon', 
        'Dougountouny', 
        'Gayah', 
        'Hidayatou', 
        'Lebekeren', 
        'Madina Wora', 
        'Salambande', 
        'Telire', 
        'Touba',
        'CSA Yembereing'
      ]
    },
    'Ratoma' => {
      facilities: [
        'AHS Yattaya',
        'AMBG Clinique',
        'Jean Mermoz',
        ['Bomboly', 'CS Bomboly'],
        'La Solidarite',
        'Bon Samaritain',
        'Nongo',
        'ADD Hamdallaye',
        'ADD Lambandji',
        ['Koloma', 'CS Koloma'],
        'Sulfonai',
        'Simbaya Gare',
        ['Kobaya', 'CS Kobaya'],
        ['Kaba', "D'Kaba", 'CS D,Kaba'],
        'Wanidara',
        'Kaporo Fondis',
        'Flambayants',
        'Lambandji'
      ]
    },
    'Tougue' => {
      facilities: [
        'Hopital',
        'Fatako',
        'Fello Koundoua',
        'Kansagui',
        'Koin',
        'Kollagui',
        'Kollet',
        'Konah',
        'Kouratongo',
        'Tangaly',
        ['CSU', 'Tougué Centre']
      ]
    },
  }


districts_facilities.each do |district_name, district_config|

  district = District.create name: district_name

  facilities = district_config[:facilities].map do |facility_config|
    facility_name = facility_config.is_a?(String) ? 
      facility_config : 
      facility_config.first
    alternative_names = facility_config.is_a?(String) ? 
      [] :
      facility_config[1,facility_config.length]
    HealthFacility.create district: district, 
      name: facility_name, 
      alternative_names: alternative_names
  end

end




