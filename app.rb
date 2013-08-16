#encoding: utf-8

require_relative 'init'

def send_view(view)
  res.write File.read(File.join('public', "#{view}.html"))
end

def send_json(document)
  res['Content-Type'] = 'application/json; charset=utf-8'
  res.write ActiveSupport::JSON.encode(document)
end

def current_user(req)
  puts req.class
  puts req
  user = Session.authenticate(req.session[:sid])
  if user
    user
  else
    nil
  end
end

def init_session(req, user)
  sid = SecureRandom.uuid
  req.session[:sid] = sid
  Session.create!(sid: sid, user: user)
end

Cuba.define do
  on 'models' do
    on ":sid" do |sid|
      user = current_user(sid)
      if user == nil
        res.status = 401
      else
        # ===============
        # REST overrides
        # ===============
        
        # =======================
        # Default REST interface
        # =======================
        on ':model_pluralized' do |model_pluralized|
          model = model_pluralized.singularize.camelize.constantize
          if model.rest?
            on ":id" do |document_id|

              # REST read individual document
              on get do
                if model.rest?(:read)
                  send_json(model.find(document_id).as_external_document)
                else
                  res.status = 401
                end
              end

              # REST update()
              on put, param('data') do |client_model| 
                if model.rest?(:update)
                  LOG.info "REST update. #{user.email} updates document #{document_id} from #{model.name}."
                  model.find(document_id).external_update!(client_model)
                else
                  res.status = 401
                end
              end
              
              # REST delete()
              on delete do
                if model.rest?(:delete)
                  LOG.info "REST delete. #{user.email} deletes document #{document_id} from #{model.name}."
                  model.find(document_id).delete
                else
                  res.status = 401
                end
              end
            end

            on get do
              # REST read()
              if model.rest?(:read)
                send_json(model.all.map {|m| m.as_external_document})
              else
                res.status = 401
              end
            end

            # REST create()
            on post, param('data') do
              if model.rest?(:create)
                #
              else
                res.status = 401
              end
            end
          else
            res.status = 401
          end
        end
      end
    end
  end
  

  on '' do
    send_view "index"
  end

  on 'landing' do
    send_view "landing"
  end

  on 'test' do
    send_view "test"
  end

  on 'login', param('email'), param('password') do |email, password|
    on post do
      user = User.authenticate(email, password)
      if user
        sid = init_session(req, user)
        send_json({sid: sid})
      else
        res.status = 401 # unauthorized
        res.write "Ogiltig e-postadress eller lösenord."
      end
    end
  end
end
