unless User.exists?(role: "admin")
  # create admin if there's no admin
  email = "admin@example.com"
  password = "12345678"
  User.create!(email: email, password: password, role: "admin")
  puts "Se ha creado el administrador #{email} con contraseña #{password}"
end
