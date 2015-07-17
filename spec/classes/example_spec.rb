require 'spec_helper'

describe 'profile_rundeck' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "profile_rundeck class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('profile_rundeck') }

          it { is_expected.to contain_class('rundeck') }
  

        end
      end
    end
  end
end
