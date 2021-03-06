require 'spec_helper'

describe "Breadcrumbs" do

  include ActiveAdmin::ViewHelpers

  describe "generating a trail from paths" do

    def params; {}; end
    def link_to(name, url); {:name => name, :path => url}; end

    let(:user)        { double  display_name: 'Jane Doe' }
    let(:user_config) { double  find_resource: user,
                                resource_name: double(route_key: 'users') }
    let(:post)        { double  display_name: 'Hello World' }
    let(:post_config) { double  find_resource: post,
                                belongs_to_config: double(target: user_config),
                                resource_name: double(route_key: 'posts') }

    let :active_admin_config do
      post_config
    end

    let(:trail) { breadcrumb_links(path) }

    context "when request '/admin'" do
      let(:path) { "/admin" }

      it "should not have any items" do
        trail.size.should == 0
      end
    end

    context "when path '/admin/users'" do
      let(:path) { "/admin/users" }

      it "should have one item" do
        trail.size.should == 1
      end
      it "should have a link to /admin" do
        trail[0][:name].should == "Admin"
        trail[0][:path].should == "/admin"
      end
    end

    context "when path '/admin/users/1'" do
      let(:path) { "/admin/users/1" }

      it "should have 2 items" do
        trail.size.should == 2
      end
      it "should have a link to /admin" do
        trail[0][:name].should == "Admin"
        trail[0][:path].should == "/admin"
      end
      it "should have a link to /admin/users" do
        trail[1][:name].should == "Users"
        trail[1][:path].should == "/admin/users"
      end
    end

    context "when path '/admin/users/1/posts'" do
      let(:path) { "/admin/users/1/posts" }

      it "should have 3 items" do
        trail.size.should == 3
      end
      it "should have a link to /admin" do
        trail[0][:name].should == "Admin"
        trail[0][:path].should == "/admin"
      end
      it "should have a link to /admin/users" do
        trail[1][:name].should == "Users"
        trail[1][:path].should == "/admin/users"
      end

      context "when User.find(1) doesn't exist" do
        before { user_config.stub(find_resource: nil) }
        it "should have a link to /admin/users/1" do
          trail[2][:name].should == "1"
          trail[2][:path].should == "/admin/users/1"
        end
      end

      context "when User.find(1) does exist" do
        it "should have a link to /admin/users/1 using display name" do
          trail[2][:name].should == "Jane Doe"
          trail[2][:path].should == "/admin/users/1"
        end
      end
    end

    context "when path '/admin/users/4e24d6249ccf967313000000/posts'" do
      let(:path) { "/admin/users/4e24d6249ccf967313000000/posts" }

      it "should have 3 items" do
        trail.size.should == 3
      end
      it "should have a link to /admin" do
        trail[0][:name].should == "Admin"
        trail[0][:path].should == "/admin"
      end
      it "should have a link to /admin/users" do
        trail[1][:name].should == "Users"
        trail[1][:path].should == "/admin/users"
      end

      context "when User.find(4e24d6249ccf967313000000) doesn't exist" do
        before { user_config.stub(find_resource: nil) }
        it "should have a link to /admin/users/4e24d6249ccf967313000000" do
          trail[2][:name].should == "4e24d6249ccf967313000000"
          trail[2][:path].should == "/admin/users/4e24d6249ccf967313000000"
        end
      end

      context "when User.find(4e24d6249ccf967313000000) does exist" do
        before do
          user_config.stub find_resource: double(display_name: 'Hello :)')
        end
        it "should have a link to /admin/users/4e24d6249ccf967313000000 using display name" do
          trail[2][:name].should == "Hello :)"
          trail[2][:path].should == "/admin/users/4e24d6249ccf967313000000"
        end
      end
    end

    context "when path '/admin/users/1/coments/1'" do
      let(:path) { "/admin/users/1/posts/1" }

      it "should have 4 items" do
        trail.size.should == 4
      end
      it "should have a link to /admin" do
        trail[0][:name].should == "Admin"
        trail[0][:path].should == "/admin"
      end
      it "should have a link to /admin/users" do
        trail[1][:name].should == "Users"
        trail[1][:path].should == "/admin/users"
      end
      it "should have a link to /admin/users/1" do
        trail[2][:name].should == "Jane Doe"
        trail[2][:path].should == "/admin/users/1"
      end
      it "should have a link to /admin/users/1/posts" do
        trail[3][:name].should == "Posts"
        trail[3][:path].should == "/admin/users/1/posts"
      end
    end

    context "when path '/admin/users/1/coments/1/edit'" do
      let(:path) { "/admin/users/1/posts/1/edit" }

      it "should have 5 items" do
        trail.size.should == 5
      end
      it "should have a link to /admin" do
        trail[0][:name].should == "Admin"
        trail[0][:path].should == "/admin"
      end
      it "should have a link to /admin/users" do
        trail[1][:name].should == "Users"
        trail[1][:path].should == "/admin/users"
      end
      it "should have a link to /admin/users/1" do
        trail[2][:name].should == "Jane Doe"
        trail[2][:path].should == "/admin/users/1"
      end
      it "should have a link to /admin/users/1/posts" do
        trail[3][:name].should == "Posts"
        trail[3][:path].should == "/admin/users/1/posts"
      end
      it "should have a link to /admin/users/1/posts/1" do
        trail[4][:name].should == "Hello World"
        trail[4][:path].should == "/admin/users/1/posts/1"
      end
    end

  end
end
