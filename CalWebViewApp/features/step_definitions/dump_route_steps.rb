
Then(/^I can call \/dump$/) do
  res = http({method: :get, path: 'dump'})
  expect(res).to be_truthy
  expect(res).not_to be ''
end
