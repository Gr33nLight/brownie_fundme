from scripts.utils import get_account
from brownie import network, config, FundMe


def deploy_fund_me():
    account = get_account()

    if network.show_active() != "development":
        price_feed_addr = config["networks"][network.show_active()]["price_feed_addr"]
    else:
        pass

    fund_me = FundMe.deploy(
        price_feed_addr,
        {"from": account},
        publish_source=True,
    )
    print(f"Contract deployed to {fund_me.address}")


def main():
    deploy_fund_me()
    pass
