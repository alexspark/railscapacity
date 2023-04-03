require "test_helper"

class ServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @server = servers(:one)
  end

  test "should get index" do
    get servers_url
    assert_response :success
  end

  test "should get new" do
    get new_server_url
    assert_response :success
  end

  test "should create server" do
    assert_difference("Server.count") do
      post servers_url, params: { server: { cpu: @server.cpu, dedicated_cpu: @server.dedicated_cpu, instance_type: @server.instance_type, paas: @server.paas, price_per_month: @server.price_per_month, provider: @server.provider, ram: @server.ram, vps: @server.vps } }
    end

    assert_redirected_to server_url(Server.last)
  end

  test "should show server" do
    get server_url(@server)
    assert_response :success
  end

  test "should get edit" do
    get edit_server_url(@server)
    assert_response :success
  end

  test "should update server" do
    patch server_url(@server), params: { server: { cpu: @server.cpu, dedicated_cpu: @server.dedicated_cpu, instance_type: @server.instance_type, paas: @server.paas, price_per_month: @server.price_per_month, provider: @server.provider, ram: @server.ram, vps: @server.vps } }
    assert_redirected_to server_url(@server)
  end

  test "should destroy server" do
    assert_difference("Server.count", -1) do
      delete server_url(@server)
    end

    assert_redirected_to servers_url
  end
end
