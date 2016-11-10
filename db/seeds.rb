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
        ['Hopital', 'Hôpital']
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
        ['Hopital', 'Boke', 'Hôpital'],
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
        ['Hopital', 'Hôpital']
        ['Fily', 'CS Fily'],
        ['Doumbouyah', 'CS Doumbouyah'],
        ['Maneah', 'CS Maneah'],
        ['Kouriah', 'CS Kouriah', 'KOURIA'],
        ['Wonkifong', 'CS Wonkifong']
      ]
    },
    'Dixinn' => {
      facilities: [
        'Macire',
        ['Hafia', 'CS Hafia'],
        ['Hopital Dixinn', 'Dixinn'],
        ['CMC Miniere', 'Miniere']
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
        ['Hopital', 'Hôpital']
        ['Khorira', 'CS Khorira'],
        'CSU',
        ['Ouassou', 'CS Ouassou'],
        ['Falessade', 'CS Falessade', 'Falessadé'],
        ['Tanene', 'CS Tanene'],
        ['Kondeyah', 'CS Kondeyah'],
        'CMC Kondeyah',
        ['Bady', 'CS Bady'],
        ['Tondon', 'CS Tondon']
      ],
      alternative_names: ['Dubréka']
    },
    'Forecariyah' => {
      facilities: [
        ['Hopital', 'Hoipital'],
        'Bassia',
        ['Maférinyah', 'Maferinyah', 'Maferinyag'],
        ['Farmoréah ', 'Farmoreah', 'Farmoriah'],
        ['Bokariah', 'Bokaria'],
        'Kakossa',
        'Moussayah',
        'Benty',
        ['CSU', 'C S U'],
        'Sikhourou',
        'Kaback'
      ],
      alternative_names: ['Forécariah']
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
        ['Hopital', 'Hôpital', 'HP Gaoual']
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
        ['Hopital', 'Hôpital']
        'Sareboido',
        'Termesse',
        'Guingan',
        'Youkounkoun',
        'Sambailo',
        'Kamaby',
        'CSU'
      ],
      alternative_names: ['KOUNDRA']
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
        ['Hopital', 'H RL', 'Labé', 'Labe'],
        'Bowloko',
        'Daka',
        'Dalein',
        ['Dara Labé', 'Dara Labe', 'Daralabé', 'Daralabe'],
        ['Diari', 'CS Diari'],
        'Dionfo',
        ['Fafabhé', 'Fafabhe', 'CS fafabhe'],
        ['Garambé', 'Garambe'],
        ['Hafia', 'CS HAFIA'],
        'Kalan',
        ['Kourmangui', 'CS Kouramangui'],
        ['Leysaré', 'Leysare', 'CS LEYSARE'],
        ['Lombona', 'Lombonna'],
        'Pellel',
        ['Popodra', 'Popodara',
        ['Sannou', 'CS Sannou'],
        'Tountouroun',
        ['CCS Noussy', 'CS noussy', 'Noussy']
      ],
      alternative_names: ['Labé']
    },
    'Lelouma' => {
      facilities: [
        ['Hopital', 'LELOUMA', 'HP LELOUMA'], 
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
        ['Linsan', 'Linsan Saran']
      ]
    },
    'Matam' => {
      facilities: [
        ['Hopital', 'Hôpital']
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
        ['Hopital', 'Hôpital', 'HÔPITAL  Mali'],
        ['CSU', 'CSU Mali'], 
        'Fougou',
        'Balaki', 
        'Donghel Sigon', 
        'Dougountouny', 
        'Gayah', 
        'Hidayatou', 
        ['Lebekeren', 'Lébékeren'] ,
        ['Madina Wora', 'Madina  wora'],
        ['Salambande', 'Salambandé'],
        'Telire', 
        'Touba',
        ['CSA Yembering','CSA Yembereing', 'Yembering', 'Yembereing']
      ]
    },
    'Ratoma' => {
      facilities: [
        ['CMC Ratoma', 'CMC']
        'AHS Yattaya',
        'AMBG Clinique',
        'Jean Mermoz',
        ['Bomboly', 'CS Bomboly'],
        'La Solidarite',
        'Bon Samaritain',
        'Nongo',
        'ADD Hamdallaye',
        ['Lambanyi', 'ADD Lambandji', 'Lambandji',
        ['Koloma', 'CS Koloma'],
        'Sonfonia',
        'Sulfonai',
        'Simbaya Gare',
        ['Kobaya', 'CS Kobaya'],
        ['Kaba', "D'Kaba", 'CS D,Kaba'],
        'Wanidara',
        ['Kaporo Fondis', 'Kaporo'],
        ['Flamboyant', 'Flamboya','Flambayants']
      ],
      alternative_names: ['DCS Ratoma']
    },
    'Tougue' => {
      facilities: [
        ['Hopital', 'Hôpital']
        'Fatako',
        'Fello Koundoua',
        'Kansagui',
        'Koin',
        'Kollagui',
        'Kollet',
        'Konah',
        'Kouratongo',
        'Tangaly',
        ['CSU Tougué', 'Tougué Centre', 'CSU', 'CSU/Tougué']
      ],
      alternative_names: ['Tougué']
    },
  }


districts_facilities.each do |district_name, district_config|

  alternative_names = district_config[:alternative_names] || []
  district = District.create name: district_name, 
    alternative_names: alternative_names

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




