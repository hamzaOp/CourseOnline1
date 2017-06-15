require "rails_helper"
RSpec.feature "Users can edit existing tickets" do
  let(:author) { FactoryGirl.create(:user) }
  let(:course) { FactoryGirl.create(:course) }
  let(:ticket) { FactoryGirl.create(:ticket, course: course, author:author) }
  before do
    assign_role!(author, :editor, course)
    login_as(author)
    visit course_ticket_path(course, ticket)
    click_link "Edit Ticket"
  end
  scenario "with valid attributes" do
    fill_in "Name", with: "Make it really shiny!"
    click_button "Update Ticket"
    expect(page).to have_content "Ticket has been updated."
    within("#ticket h2") do
      expect(page).to have_content "Make it really shiny!"
      expect(page).not_to have_content ticket.name
    end
  end
  scenario "with invalid attributes" do
    fill_in "Name", with: ""
    click_button "Update Ticket"
    expect(page).to have_content "Ticket has not been updated."
  end
end