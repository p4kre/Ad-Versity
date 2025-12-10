10.times do
    Contact.create!(
      first_name: Faker::Name.first_name,
      last_name:  Faker::Name.last_name,
      email:      Faker::Internet.email,
      job_title:  "Marketing Manager",
      company:    "TestCorp"
    )
  end
  
  audience = Audience.create!(name: "Demo Audience", description: "Sample audience for demo")
  
  Contact.limit(5).each do |contact|
    AudienceContact.create!(audience: audience, contact: contact)
  end
  
  Campaign.create!(name: "Demo Campaign", objective: "Lead Gen", budget: 1000, channel: :meta, external_id: "12345")
  