require "rails_helper"

RSpec.describe "Static pages", type: :request do

  it "access to correct pages" do
    get static_pages_home_url
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/home"
    assert_select "title", "Home | No Books, No Life"

    get static_pages_help_url
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/help"
    assert_select "title", "Help | No Books, No Life"

    get static_pages_about_url
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/about"
    assert_select "title", "About | No Books, No Life"

    get static_pages_contact_url
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/contact"
    assert_select "title", "Contact | No Books, No Life"
  end

end
