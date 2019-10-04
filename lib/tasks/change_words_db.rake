namespace :change_words_db do
  desc "change prompting to independence on MAPP grid"

  task :add_independence_to_mastercsd_axis => :environment do
    MasterCsdAxis.where(name: 'prompting').each do |t|
      t.update_attribute :display_name, 'Independence'

    end


    #Report.find_each(&:save)
  end
end