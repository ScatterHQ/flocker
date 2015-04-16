"""
Tests for ``flocker.provision._ssh._conch``.
"""

from effect.twisted import perform

from twisted.internet import reactor
from twisted.python.filepath import FilePath
from twisted.trial.unittest import TestCase


from .._ssh import run, put, run_remotely
from .._ssh._conch import make_dispatcher


from flocker.testtools.ssh import create_ssh_server, create_ssh_agent


class Tests(TestCase):
    """
    Tests for conch implementation of ``flocker.provision._ssh.RunRemotely``.
    """

    def setUp(self):
        self.sshd_config = FilePath(self.mktemp())
        self.server = create_ssh_server(self.sshd_config)
        self.addCleanup(self.server.restore)

        self.agent = create_ssh_agent(self.server.key_path)
        self.addCleanup(self.agent.restore)

    def test_stuff(self):
        command = run_remotely(
            username="root",
            address=str(self.server.ip),
            port=self.server.port,
            commands=run("echo hello"),
        )

        d = perform(
            make_dispatcher(reactor),
            command,
        )
        return d

    def test_put(self):

        command = run_remotely(
            username="root",
            address=str(self.server.ip),
            port=self.server.port,
            commands=put(content="hello", path="file"),
        )

        d = perform(
            make_dispatcher(reactor),
            command,
        )

        def check(_):
            self.assertEqual(self.server.home.child('file').getContent(),
                             "hello")
        d.addCallback(check)
        return d
