$prodSubName = "prodsub"
$devSubName = "devsub"

$rgname1 = "azuse2prdrg"
$rgname2 = "azuse2devrg"
$rgname3 = "azuse2prdrg"
$rgname4 = "azuse2itvmrg"
$location = "eastus2"
$erCircuitName = 'ExpressRoute001'

$GWName1 = "azuse2prdgw1"
$GWIPName1 = "azuse2prdgwip1"
$GWIPconfName1 = "gwipconf1"
$VNetName1 = "azuse2prdvn1"

$GWName2 = "azuse2devgw2"
$GWIPName2 = "azuse2devgwip2"
$GWIPconfName2 = "gwipconf2"
$VNetName2 = "azuse2devvn2"

$GWName3 = "azuse2prdgw3"
$GWIPName3 = "azuse2prdgwip3"
$GWIPconfName3 = "gwipconf3"
$VNetName3 = "azuse2prdvn3"

$GWName4 = "azuse2prdgw4"
$GWIPName4 = "azuse2prdgwip4"
$GWIPconfName4 = "gwipconf4"
$VNetName4 = "azuse2prdvn4"

#New-AzureRmResourceGroup -Name $rgname1 -Location $location
#New-AzureRmResourceGroup -Name $rgname3 -Location $location
#New-AzureRmResourceGroup -Name $rgname4 -Location $location


Select-AzureRmSubscription -SubscriptionName $prodSubName

$virtualNetwork1 = New-AzureRmVirtualNetwork -Name 'azuse2prdvn1' -ResourceGroupName $rgname1 -Location $location -AddressPrefix "10.5.0.0/22"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $virtualNetwork1 -AddressPrefix "10.5.3.128/28"
Udd-AzureRmVirtualNetworkSubnetConfig -Name 'Sub1' -VirtualNetwork $virtualNetwork1 -AddressPrefix "10.5.0.0/24"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'SUB2' -VirtualNetwork $virtualNetwork1 -AddressPrefix "10.5.1.0/24"
  
$virtualNetwork1 | Set-AzureRmVirtualNetwork


$virtualNetwork3 = New-AzureRmVirtualNetwork -Name 'azuse2prdvn3' -ResourceGroupName $rgname3 -Location $location -AddressPrefix "10.5.8.0/22"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $virtualNetwork3 -AddressPrefix "10.5.11.0/28"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'Sub1' -VirtualNetwork $virtualNetwork3 -AddressPrefix "10.5.8.0/24"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'Sub2' -VirtualNetwork $virtualNetwork3 -AddressPrefix "10.5.9.0/24"
   
$virtualNetwork3 | Set-AzureRmVirtualNetwork


$virtualNetwork4 = New-AzureRmVirtualNetwork -Name 'azuse2prdvn4' -ResourceGroupName $rgname4 -Location $location -AddressPrefix "10.5.16.0/21"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $virtualNetwork4 -AddressPrefix "10.5.20.0/28"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'Sub1' -VirtualNetwork $virtualNetwork4 -AddressPrefix "10.5.16.0/22"
    
$virtualNetwork4 | Set-AzureRmVirtualNetwork



$vnet1 = Get-AzureRmVirtualNetwork -Name $VNetName1 -ResourceGroupName $rgname1
$vnet3 = Get-AzureRmVirtualNetwork -Name $VNetName3 -ResourceGroupName $rgname3
$vnet4 = Get-AzureRmVirtualNetwork -Name $VNetName4 -ResourceGroupName $rgname4

$subnet1 = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet1
$subnet3 = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet3
$subnet4 = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet4

$pip1 = New-AzureRmPublicIpAddress -Name $GWIPName1  -ResourceGroupName $rgname1 -Location $Location -AllocationMethod Dynamic
$pip3 = New-AzureRmPublicIpAddress -Name $GWIPName3  -ResourceGroupName $rgname3 -Location $Location -AllocationMethod Dynamic
$pip4 = New-AzureRmPublicIpAddress -Name $GWIPName4  -ResourceGroupName $rgname4 -Location $Location -AllocationMethod Dynamic

$ipconf1 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 -Subnet $subnet1 -PublicIpAddress $pip1
$ipconf3 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName3 -Subnet $subnet3 -PublicIpAddress $pip3
$ipconf4 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName4 -Subnet $subnet4 -PublicIpAddress $pip4

$gw1 = New-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $rgname1 -Location $Location -IpConfigurations $ipconf1 -GatewayType Expressroute -GatewaySku Standard
$gw3 = New-AzureRmVirtualNetworkGateway -Name $GWName3 -ResourceGroupName $rgname3 -Location $Location -IpConfigurations $ipconf3 -GatewayType Expressroute -GatewaySku Standard
$gw4 = New-AzureRmVirtualNetworkGateway -Name $GWName4 -ResourceGroupName $rgname4 -Location $Location -IpConfigurations $ipconf4 -GatewayType Expressroute -GatewaySku Standard



$circuit = Get-AzureRmExpressRouteCircuit -Name $erCircuitName -ResourceGroupName "Express-Route-QorC"


New-AzureRmVirtualNetworkGatewayConnection -Name "azuse2prderc1" -ResourceGroupName $rgname1 -Location $location -VirtualNetworkGateway1 $gw1 -PeerId $circuit.Id -ConnectionType ExpressRoute
New-AzureRmVirtualNetworkGatewayConnection -Name "azuse2prderc3" -ResourceGroupName $rgname3 -Location $location -VirtualNetworkGateway1 $gw3 -PeerId $circuit.Id -ConnectionType ExpressRoute
New-AzureRmVirtualNetworkGatewayConnection -Name "azuse2prderc4" -ResourceGroupName $rgname4 -Location $location -VirtualNetworkGateway1 $gw4 -PeerId $circuit.Id -ConnectionType ExpressRoute


Select-AzureRmSubscription -SubscriptionName $devSubName

#New-AzureRmResourceGroup -Name $rgname2 -Location $location

$virtualNetwork2 = New-AzureRmVirtualNetwork -Name 'azuse2devvn2' -ResourceGroupName $rgname2 -Location $location -AddressPrefix "10.5.4.0/22"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $virtualNetwork2 -AddressPrefix "10.5.7.0/28"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'Sub1' -VirtualNetwork $virtualNetwork2 -AddressPrefix "10.5.6.0/24"
Add-AzureRmVirtualNetworkSubnetConfig -Name 'Sub2' -VirtualNetwork $virtualNetwork2 -AddressPrefix "10.5.4.0/23"
$virtualNetwork2 | Set-AzureRmVirtualNetwork


$vnet2 = Get-AzureRmVirtualNetwork -Name $VNetName2 -ResourceGroupName $rgname2
$subnet2 = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet2
$pip2 = New-AzureRmPublicIpAddress -Name $GWIPName2  -ResourceGroupName $rgname2 -Location $Location -AllocationMethod Dynamic
$ipconf2 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName2 -Subnet $subnet2 -PublicIpAddress $pip2
$gw2 = New-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $rgname2 -Location $Location -IpConfigurations $ipconf2 -GatewayType Expressroute -GatewaySku Standard


Select-AzureRmSubscription -SubscriptionName $prodSubName

Add-AzureRmExpressRouteCircuitAuthorization -ExpressRouteCircuit $circuit -Name "azuse2devera1"
Set-AzureRmExpressRouteCircuit -ExpressRouteCircuit $circuit

$circuit = Get-AzureRmExpressRouteCircuit -Name $erCircuitName -ResourceGroupName "Express-Route-RG"
$auth1 = Get-AzureRmExpressRouteCircuitAuthorization -ExpressRouteCircuit $circuit -Name "azuse2devera1"

Select-AzureRmSubscription -SubscriptionName $devSubName
New-AzureRmVirtualNetworkGatewayConnection -Name "azuse2deverc2" -ResourceGroupName $rgname2 -Location $location -VirtualNetworkGateway1 $gw2 -PeerId $circuit.Id -ConnectionType ExpressRoute -AuthorizationKey $auth1.AuthorizationKey



