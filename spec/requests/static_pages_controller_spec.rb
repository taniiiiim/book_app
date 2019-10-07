require "rails_helper"

RSpec.describe "Static pages", type: :request do

  it "access to correct pages" do
    get root_path
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/home"
    assert_select "title", "Home | No Books, No Life"

    get help_path
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/help"
    assert_select "title", "Help | No Books, No Life"

    get about_path
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/about"
    assert_select "title", "About | No Books, No Life"

    get contact_path
    expect(response.status).to eq 200
    expect(response).to render_template "static_pages/contact"
    assert_select "title", "Contact | No Books, No Life"
  end

end
