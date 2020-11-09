RSpec::Matchers.define :have_table_with_exact_data do |expected|
  match do |_actual|
    actual_data == expected
  end

  failure_message do |_actual|
    "expected that #{expected} but is #{actual_data}"
  end

  def actual_header
    Array(first("table").all("th").map(&:text))
  end

  def actual_values
    Array(first("table").all("tbody tr").map { |tr| tr.all("td").map { |e| e.text.to_s.strip } })
  end

  def actual_data
    actual_values.insert(0, actual_header)
  end
end
