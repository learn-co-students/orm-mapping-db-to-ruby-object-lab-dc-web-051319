class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      SQL

    DB[:conn].execute(sql).map{|student_row| self.new_from_db(student_row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = name
      SQL

    student_name = DB[:conn].execute(sql)[0][1]
    Student.all.find{|student| student.name == student_name}
  end
  
  def self.all_students_in_grade_9
    Student.all.select{ |student| student.grade == "9" }
  end

  def self.students_below_12th_grade
    Student.all.select{ |student| student.grade.to_i < 12 }
  end

  def self.first_X_students_in_grade_10(num)
    tenth_graders = Student.all.select{ |student| student.grade == "10" }
    tenth_graders.slice(0, num)
  end

  def self.first_student_in_grade_10
    Student.all.select{ |student| student.grade == "10" }.first
  end

  def self.all_students_in_grade_X(grade)
    Student.all.select{ |student| student.grade == grade.to_s }
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
