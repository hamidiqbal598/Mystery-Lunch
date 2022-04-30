require "rails_helper"

RSpec.describe MysteriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/mysteries").to route_to("mysteries#index")
    end

    it "routes to #new" do
      expect(get: "/mysteries/new").to route_to("mysteries#new")
    end

    it "routes to #show" do
      expect(get: "/mysteries/1").to route_to("mysteries#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/mysteries/1/edit").to route_to("mysteries#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/mysteries").to route_to("mysteries#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/mysteries/1").to route_to("mysteries#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/mysteries/1").to route_to("mysteries#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/mysteries/1").to route_to("mysteries#destroy", id: "1")
    end
  end
end
