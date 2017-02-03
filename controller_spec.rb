describe PostsController do
  let(:valid_attributes){
    {
      title: 'This is for testing',
      description: 'This spec was generated by rspec-rails when you ran the scaffold generator.
                     It demonstrates how one might use RSpec to specify the controller code that
                     was generated by Rails when you ran the scaffold generator.'
    }
  }

  let(:invalid_attributes){
    {
      title: nil,
      description: nil
    }
  }

  let(:valid_session){
    {}
  }

  describe "GET #index" do
    it "assign all posts as @posts" do
      post = Post.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe "GET #show" do
    it "assigns the requested post as @post" do
      post = Post.create! valid_attributes
      get :show, {:id => post.to_param}, valid_session
      expect(assigns(:post)).to eq(post)
    end
  end

  describe "GET #new" do
    it "assigns a new post as @post" do
      get :new, {}, valid_session
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "GET #edit" do
    it "assigns the requsted post as @post" do
      post = Post.create! valid_attributes
      get :edit, {:id => post.to_param}, valid_session
      expect(assigns(:post)).to eq(post)
    end
  end

  describe "POST #create" do
    context "with valid params" do

      it "creates a new Post" do
        expect {
          post :create, {:post => valid_attributes}, valid_session
        }.to change(Post, :count).by(1)
      end

      it "assigns a newly created post as @post" do
        post :create, {:post => valid_attributes}, valid_session
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it "redirects to the created post" do
        post :create, {:post => valid_attributes}, valid_session
        expect(response).to redirect_to(Post.last)
      end
    end

      context "with invalid params" do

        it "assigns a newly created but unsaved post as @post" do
          post :create, {:post => invalid_attributes}, valid_session
          expect(assigns(:post)).to be_a_new(Post)
        end

        it "re renders the new template" do
          post :create, {:post => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end

      end
    end

    describe "PUT #update" do

      context "with valid params" do

        let(:new_attributes){
          {
            title: 'This is for testing 12344',
            description: 'This spec 12234 was generated by rspec-rails when you ran the scaffold generator.
                           It demonstrates how one might use RSpec to specify the controller code that
                           was generated by Rails when you ran the scaffold generator.'
          }
        }

        it "update the requested post" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => new_attributes}, valid_session
          post.reload
          expect(post.title).to eq(new_attributes[:title])
          expect(post.description).to eq(new_attributes[:description])
        end

        it "assigns the requested post as @post" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => valid_attributes}, valid_session
          expect(assigns(:post)).to eq(post)
        end

        it "redirects to the post" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => valid_attributes}, valid_session
          expect(response).to redirect_to(post)
        end
      end

      context "with invalid params" do

        it "assigns the post to @post" do
          post = Post.create! valid_attributes
          put :update, { :id => post.to_param, :post => invalid_attributes }, valid_session
          expect(assigns(:post)).to eq(post)
        end

        it "re render the edit" do
          post = Post.create! valid_attributes
          put :update, { :id => post.to_param, :post => invalid_attributes }, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do

      it "destorys the requested post" do
          post = Post.create! valid_attributes
          expect{
            delete :destroy, { :id => post.to_param }, valid_session
          }.to change(Post, :count).by(-1)
      end

      it "redirects to the index page" do
        post = Post.create! valid_attributes
        delete :destroy, { :id => post.to_param }, valid_session
        expect(response).to redirect_to(posts_url)
      end
    end
end


describe UsersController do
  describe "GET #index" do
    it "populates an array of contacts" do
      contact = FactoryGirl.create(:user)
      contact1 = FactoryGirl.create(:user)
      contact2 = FactoryGirl.create(:user)
      get :index
      expect(assigns(:users)).to eq([contact, contact1, contact2])
    end

    it "renders the :index view"  do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "render a new page" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end


  describe "POST #create" do
    context "with valid attributes" do
      it "Creates new contact" do
        expect{ post :create, user: {:first_name => "Bala", :last_name => "Raju"} }.to change(User,:count).by(1)
      end
      it "redirects to the new contact" do
        post :create,
        user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to :action => :show,
                                     :id => assigns(:user).id
      end
    end

    context "with invalid attributes" do
      it "creates a new contact with out invalid contact details" do
        expect{
          post :create, user: FactoryGirl.attributes_for(:invalid_user) }.to_not change(User, :count)

     end

     it "Render to a new page " do
      post :create,
      user: FactoryGirl.attributes_for(:invalid_user)
      expect(response).to render_template(:new)
     end
    end
  end

  describe "GET #show" do
    it "Showing a particular user" do

      user = FactoryGirl.create(:user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end

   it "showing template of show page" do
    user = FactoryGirl.create(:user)
    get :show, id: user
    expect(response).to render_template :show
   end
  end

  describe "DELETE #destroy" do
    before :each do
      @user = FactoryGirl.create(:user)
    end

   it "After deleting user count change to -1 " do
    expect{
      delete :destroy, id: @user
    }.to change(User, :count).by(-1)
   end

   it "After delete page redirect_to index" do
    delete :destroy, id: @user
    expect(response).to redirect_to(users_path)
   end
  end

  describe "GET #edit" do
    it "showing edit template" do
      user = FactoryGirl.create(:user)
      get :edit, id: user
      expect(response).to render_template :edit
    end
  end

  describe "PUT #update" do
    it "update user details"
    it "update user valid details"
  end

end
